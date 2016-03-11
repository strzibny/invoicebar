module InvoiceBar
  class InvoicesController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :set_user_accounts, only: [:new, :create, :edit, :update, :from_template]
    before_action :set_user_contacts, only: [:new, :create, :edit, :update, :from_template]
    before_action :set_user_invoice_templates, only: [:new, :create, :edit, :update, :from_template]
    before_action :set_invoice, only: [:show, :edit, :update, :destroy]

    # GET /invoices
    # GET /invoices.json
    def index
      @invoices = current_user.invoices.page(params[:page])
      respond_on_index @invoices
    end

    # GET /invoices/1
    # GET /invoices/1.json
    # GET /invoices/1.pdf
    def show
      @invoice = current_user.invoices.find(params[:id])
      @address = @invoice.address
      @account = current_user.accounts.find(@invoice.account_id)

      respond_to do |format|
        format.html { render :show }
        format.json { render json: object }
        format.pdf { send_data @invoice.to_pdf, type: 'application/pdf', disposition: 'inline' }
      end
    end

    # GET /invoices/new
    def new
      # Set the number of the document
      next_issued_in_line = current_user.invoices.issued.size + 1
      next_received_in_line = current_user.invoices.received.size + 1
      @next_issued = ::InvoiceBar::Generators.issued_invoice_number(next_issued_in_line)
      @next_received = ::InvoiceBar::Generators.received_invoice_number(next_received_in_line)

      @invoice = Invoice.new
      @invoice.number = @next_issued
      @invoice.items.build
      @invoice.build_address
      @invoice.issue_date = Date.today
      @invoice.due_date = @invoice.issue_date + 14.days

      respond_on_new @invoice
    end

    def create_receipt_for_invoice
      @invoice = current_user.invoices.find(params[:id])

      unless @invoice.receipt_id.blank?
        @receipt = current_user.receipts.find(@invoice.receipt_id)

        flash[:notice] = "Doklad #{@receipt.number} již vytvořen."
      else
        @receipt = Receipt.for_invoice(@invoice)

        if @invoice.issuer
          @receipt.issuer = true
          next_income_in_line = current_user.receipts.income.size + 1
          @next_number = ::InvoiceBar::Generators.income_receipt_number(next_income_in_line)
        else
          @receipt.issuer = false
          next_expense_in_line = current_user.receipts.expense.size + 1
          @next_number = ::InvoiceBar::Generators.income_receipt_number(next_income_in_line)
        end

        @receipt.number = @next_number
        @receipt.invoice = @invoice
        current_user.receipts << @receipt

        if @receipt.save
          @invoice.mark_as_paid
          @invoice.save!

          flash[:notice] = "Doklad #{@receipt.number} vytvořen."
        else
          flash[:alert] = 'Nepodařilo se vytvořit korespondující doklad.'
        end
      end

      redirect_to action: :show
    end

    def from_template
      @template = current_user.invoice_templates.find(params[:id])
      @invoice = Invoice.from_template(@template)
      respond_on_new @invoice
    end

    # POST /invoices/1
    # POST /invoices/1.json
    def create
      flash[:notice], flash[:alert] = nil, nil

      @invoice = Invoice.new(invoice_params)

      apply_templates if params[:fill_in]
      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@invoice.load_contact_from_ic(@invoice.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in] || params[:fill_in_contact] || params[:ic]
        respond_on_new @invoice
      else
        current_user.invoices << @invoice
        respond_on_create @invoice
      end
    end

    # GET /invoices/1/edit
    def edit
      respond_on_edit @invoice
    end

    # PATCH/PUT /invoices/1
    # PATCH/PUT /invoices/1.json
    def update
      flash[:notice], flash[:alert] = nil, nil

      @invoice = current_user.invoices.find(params[:id])

      apply_templates if params[:fill_in]
      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@invoice.load_contact_from_ic(@invoice.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in] || params[:fill_in_contact] || params[:ic]
        respond_on_edit @invoice
      else
        respond_on_update @invoice, invoice_params
      end
    end

    # DELETE /invoices/1
    # DELETE /invoices/1.json
    def destroy
      @invoice.destroy
      respond_on_destroy @invoice, invoice_url
    end

    def mark_as_paid
      @invoice = current_user.invoices.find(params[:id])
      @invoice.mark_as_paid
      @invoice.save!

      flash[:notice] = 'Označeno jako zaplaceno.'

      redirect_to action: :show
    end

    def mark_as_sent
      @invoice = current_user.invoices.find(params[:id])
      @invoice.mark_as_sent
      @invoice.save!

      flash[:notice] = 'Označena za odeslanou.'

      redirect_to action: :show
    end

    def received
      @section = :received
      @invoices = current_user.invoices.received
      @invoices = filter_params(@invoices)

      render action: 'index'
    end

    def issued
      @section = :issued
      @invoices = current_user.invoices.issued
      @invoices = filter_params(@invoices)

      render action: 'index'
    end

    def filter
      @invoices = current_user.invoices.limit(nil)
      @invoices = filter_params(@invoices)

      render action: 'index'
    end

    protected

      def set_invoice
        @invoice = InvoiceBar::Invoice.find(params[:id])
      end

      def invoice_params
        params.require(:invoice).permit(:number, :sent, :paid,
                                        :amount, :contact_dic, :contact_ic, :contact_name, :issue_date, :issuer,
                                        :due_date, :payment_identification_number, :issuer,
                                        :account_id, :user_id, :address, :address_attributes, :items_attributes)
      end

      def filter_params(bills)
        unless params[:from_amount].blank?
          params[:from_amount] = FormattedMoney.cents(params[:from_amount])
        end

        unless params[:to_amount].blank?
          params[:to_amount] = FormattedMoney.cents(params[:to_amount])
        end

        unless params[:status].blank?
          status = params[:status]

          paid = case status
            when 'paid' then true
            when 'not_paid' then false
            else nil
          end

          sent = case status
            when 'sent' then true
            when 'not_sent' then false
            else nil
          end
        end

        @bills = bills.for_numbers(params[:number])
                      .within_dates(params[:from_date], params[:to_date])
                      .within_amounts(params[:from_amount], params[:to_amount])
                      .including_contacts(params[:contact])
                      .paid(paid)
                      .sent(sent)
                      .order(params[:sort])
                      .page(params[:page])

        @bills
      end

      def apply_templates
        if params[:template_ids] and not params[:template_ids].empty?
          params[:template_ids].each do |template_id|
            template = current_user.invoice_templates.find(template_id)
            @invoice.apply_template(template)
          end
        end
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @invoice.use_contact(contact)
        end
      end
  end
end
