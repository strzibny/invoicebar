module InvoiceBar
  class ReceiptsController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json
    respond_to :pdf, only: [:show]

    before_action :require_login
    before_action :set_user_accounts, only: [:new, :create, :edit, :update, :from_template]
    before_action :set_user_contacts, only: [:new, :create, :edit, :update, :from_template]
    before_action :set_user_receipt_templates, only: [:new, :create, :edit, :update, :from_template]
    before_action :set_receipt, only: [:show, :edit, :update, :destroy]

    # GET /receipts
    # GET /receipts.json
    def index
      @receipts = current_user.receipts.page(params[:page])
    end

    # GET /receipts/1
    # GET /receipts/1.json
    # GET /receipts/1.pdf
    def show
      @receipt = current_user.receipts.find(params[:id])
      @address = @receipt.address
      @account = current_user.accounts.find(@receipt.account_id)

      respond_to do |format|
        format.html
        format.json
        format.pdf
      end
    end

    # GET /receipts/new
    def new
      # Set the number of the document
      next_income_in_line = current_user.receipts.income.size + 1
      next_expense_in_line = current_user.receipts.expense.size + 1
      @next_income = ::InvoiceBar::Generators.income_receipt_number(next_income_in_line)
      @next_expense = ::InvoiceBar::Generators.expense_receipt_number(next_expense_in_line)

      @receipt = Receipt.new
      @receipt.number = @next_income
      @receipt.items.build
      @receipt.build_address
      @receipt.issue_date = Date.today
    end

    # GET /receipts/1/edit
    def edit
    end

    def from_template
      @template = current_user.receipt_templates.find(params[:id])
      @receipt = Receipt.from_template(@template)

      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: @receipt }
      end
    end

    def create
      flash[:notice], flash[:alert] = nil, nil

      @receipt = Receipt.new(params[:receipt])

      apply_templates if params[:fill_in]
      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@receipt.load_contact_from_ic(@receipt.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in] || params[:fill_in_contact] || params[:ic]
        respond_to do |format|
          format.html { render action: 'new' }
          format.json { render json: @receipt }
        end
      else
        current_user.receipts << @receipt

        create! {}
      end
    end

    def update
      flash[:notice], flash[:alert] = nil, nil

      @receipt = current_user.receipts.find(params[:id])

      apply_templates if params[:fill_in]
      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@receipt.load_contact_from_ic(@receipt.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in] || params[:fill_in_contact] || params[:ic]
        respond_to do |format|
          format.html { render action: 'edit' }
          format.json { render json: @receipt }
        end
      else
        update! {}
      end
    end

    def destroy
      destroy! {}
    end

    def expence
      @section = :expence
      @receipts = current_user.receipts.expense
      @receipts = filter_params(@receipts)

      render action: 'index'
    end

    def income
      @section = :income
      @receipts = current_user.receipts.income
      @receipts = filter_params(@receipts)

      render action: 'index'
    end

    def filter
      @receipts = current_user.receipts.limit(nil)
      @receipts = filter_params(@receipts)

      render action: 'index'
    end

    protected

      def set_receipt
        @receipt = InvoiceBar::Receipt.find(params[:id])
      end

      def receipt_params
        params.require(:receipt).permit(:number, :sent, :paid,
                                        :amount, :contact_dic, :contact_ic, :contact_name, :issue_date, :issuer,
                                        :issuer,
                                        :account_id, :user_id, :address, :address_attributes, :items_attributes)
      end

      def filter_params(bills)
        @bills = bills.for_numbers(params[:number])
                      .within_dates(params[:from_date], params[:to_date])
                      .within_amounts(params[:from_amount], params[:to_amount])
                      .including_contacts(params[:contact])
                      .order(params[:sort])
                      .page(params[:page])

        @bills
      end

      def collection
        @receipts ||= end_of_association_chain.page(params[:page])
      end

      def apply_templates
        if params[:template_ids] and not params[:template_ids].empty?
          params[:template_ids].each do |template_id|
            template = current_user.receipt_templates.find(template_id)
            @receipt.apply_template(template)
          end
        end
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @receipt.use_contact(contact)
        end
      end
  end
end
