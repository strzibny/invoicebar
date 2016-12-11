require 'invoice_bar/sequence'

class InvoicesController < ApplicationController
  before_action :require_login
  before_action :set_user_accounts, only: [:new, :new_deposit, :create, :edit, :update, :from_template]
  before_action :set_user_contacts, only: [:new, :new_deposit, :create, :edit, :update, :from_template]
  before_action :set_user_invoice_templates, only: [:new, :new_deposit, :create, :edit, :update, :from_template]
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
    @address = @invoice.address
    @account = current_user.accounts.find(@invoice.account_id)

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @invoice }
      format.pdf {
        @pdf = InvoicePDF.new(@invoice).render
        send_data @pdf, type: 'application/pdf', disposition: 'inline'
      }
    end
  end

  # GET /invoices/new
  def new
    build_next_sequence_numbers

    @invoice = Invoice.new
    @invoice.number = @next_issued
    @invoice.items.build
    @invoice.build_address
    @invoice.issue_date = Date.today
    @invoice.due_date = @invoice.issue_date + 14.days

    respond_on_new @invoice
  end

  # GET /invoices/new_deposit
  def new_deposit
    build_next_deposit_sequence_numbers

    @invoice = Invoice.new
    @invoice.number = @next_issued
    @invoice.invoice_type = :deposit
    @invoice.items.build
    @invoice.build_address
    @invoice.issue_date = Date.today
    @invoice.due_date = @invoice.issue_date + 14.days

    respond_on_new @invoice
  end

  def create_receipt_for_invoice
    @invoice = current_user.invoices.where(number: params[:number]).first

    unless @invoice.receipt_id.blank?
      @receipt = current_user.receipts.find(@invoice.receipt_id)

      flash[:notice] = "Doklad #{@receipt.number} již vytvořen."
    else
      @receipt = Receipt.for_invoice(@invoice)

      if @invoice.issuer
        @receipt.issuer = true
        last_issued = current_user.receipts.income.try(:last).try(:number) || current_user.preferences[:last_income_bill_number]
        @next_number = ::InvoiceBar::Sequence.new(from: last_issued, format: income_bill_format).nextn(by: :month)
      else
        @receipt.issuer = false
        last_issued = current_user.receipts.expense.try(:last).try(:number) || current_user.preferences[:last_expense_bill_number]
        @next_number = ::InvoiceBar::Sequence.new(from: last_issued, format: expense_bill_format).nextn(by: :month)
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
    @invoice.user_name = current_user.name
    @invoice.user_tax_id = current_user.tax_id
    @invoice.user_tax_id2 = current_user.tax_id2
    @invoice.user_address = current_user.address.copy(
      addressable_type: "Invoice#user_address"
    )
    respond_on_new @invoice
  end

  # POST /invoices/1
  # POST /invoices/1.json
  def create
    flash[:notice], flash[:alert] = nil, nil

    @invoice = Invoice.new(invoice_params)

    apply_templates if params[:fill_in]
    fill_in_contact if params[:fill_in_contact]

    if params[:tax_id]
      if (@invoice.load_contact_from_tax_id(@invoice.contact_tax_id))
        flash[:notice] = I18n.t('messages.tax_id_loaded')
      else
        flash[:alert] = I18n.t('messages.cannot_load_tax_id')
      end
    end

    if params[:fill_in] || params[:fill_in_contact] || params[:tax_id]
      respond_on_new @invoice
    else
      @invoice.user_name = current_user.name
      @invoice.user_tax_id = current_user.tax_id
      @invoice.user_tax_id2 = current_user.tax_id2
      @invoice.user_address = current_user.address.copy(
        addressable_type: "Invoice#user_address"
      )
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

    apply_templates if params[:fill_in]
    fill_in_contact if params[:fill_in_contact]

    if params[:tax_id]
      if (@invoice.load_contact_from_tax_id(@invoice.contact_tax_id))
        flash[:notice] = I18n.t('messages.tax_id_loaded')
      else
        flash[:alert] = I18n.t('messages.cannot_load_tax_id')
      end
    end

    if params[:fill_in] || params[:fill_in_contact] || params[:tax_id]
      respond_on_edit @invoice
    else
      respond_on_update @invoice, invoice_params
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_on_destroy @invoice, invoices_url
  end

  def mark_as_paid
    @invoice = current_user.invoices.where(number: params[:number]).first
    @invoice.mark_as_paid
    @invoice.save!

    flash[:notice] = 'Označeno jako zaplaceno.'

    redirect_to action: :show
  end

  def mark_as_sent
    @invoice = current_user.invoices.where(number: params[:number]).first
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
      @invoice = current_user.invoices.where(number: params[:number]).first
    end

    def invoice_params
      params.require(:invoice).permit(:number, :invoice_type, :sent, :paid,
                                      :amount, :contact_tax_id2, :contact_tax_id, :contact_name, :issue_date, :issuer,
                                      :due_date, :payment_identification_number, :issuer,
                                      :account_id, :user_id, :note,
                                      address_attributes: [:street, :street_number, :city, :city_part, :postcode, :extra_address_line],
                                      items_attributes: [:id, :name, :number, :price, :unit, :deposit_invoice_id, :_destroy])
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

      bills = bills.deposit if params[:deposit] == 'true'

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

    # Set the number of the document
    def build_next_sequence_numbers
      begin
        last_issued = current_user.invoices.issued.try(:last).try(:number) || current_user.preferences[:last_issued_invoice]
        @next_issued = ::InvoiceBar::Sequence.new(from: last_issued, format: issued_invoice_format).nextn(by: :month)
      rescue InvoiceBar::Sequence::ParseError
        @next_issued = ''
      end

      begin
        last_received = current_user.invoices.received.try(:last).try(:number) || current_user.preferences[:last_received_invoice]
        @next_received = ::InvoiceBar::Sequence.new(from: last_received, format: received_invoice_format).nextn(by: :month)
      rescue InvoiceBar::Sequence::ParseError
        @next_received = ''
      end
    end

    def build_next_deposit_sequence_numbers
      begin
        last_issued = current_user.invoices.issued_deposit.try(:last).try(:number) || current_user.preferences[:last_issued_deposit_invoice]
        @next_issued = ::InvoiceBar::Sequence.new(from: last_issued, format: issued_deposit_invoice_format).nextn(by: :month)
      rescue InvoiceBar::Sequence::ParseError
        @next_issued = ''
      end

      begin
        last_received = current_user.invoices.received_deposit.try(:last).try(:number) || current_user.preferences[:last_received_deposit_invoice]
        @next_received = ::InvoiceBar::Sequence.new(from: last_received, format: received_deposit_invoice_format).nextn(by: :month)
      rescue InvoiceBar::Sequence::ParseError
        @next_received = ''
      end
    end

    def issued_invoice_format
      InvoiceBar::Sequence.parse_format(
        current_user.preferences[:issued_invoice_sequence]
      ) || ['VF', :year, :month]
    end

    def received_invoice_format
      InvoiceBar::Sequence.parse_format(
        current_user.preferences[:received_invoice_sequence]
      ) || ['PF', :year, :month]
    end

    def issued_deposit_invoice_format
      InvoiceBar::Sequence.parse_format(
      current_user.preferences[:issued_deposit_invoice_sequence]
      ) || ['ZVF', :year, :month]
    end

    def received_deposit_invoice_format
      InvoiceBar::Sequence.parse_format(
      current_user.preferences[:received_deposit_invoice_sequence]
      ) || ['ZPF', :year, :month]
    end

    def income_bill_format
      InvoiceBar::Sequence.parse_format(
        current_user.preferences[:income_bill_sequence]
      ) || ['VD', :year, :month]
    end

    def expense_bill_format
      InvoiceBar::Sequence.parse_format(
        current_user.preferences[:expense_bill_sequence]
      ) || ['PD', :year, :month]
    end
end
