require 'invoice_bar/sequence'

class ReceiptsController < ApplicationController
  before_action :require_login
  before_action :set_user_accounts, only: [:new, :create, :edit, :update, :from_template]
  before_action :set_user_contacts, only: [:new, :create, :edit, :update, :from_template]
  before_action :set_user_receipt_templates, only: [:new, :create, :edit, :update, :from_template]
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  # GET /receipts
  # GET /receipts.json
  def index
    @receipts = current_user.receipts.page(params[:page])
    respond_on_index @receipts
  end

  # GET /receipts/1
  # GET /receipts/1.json
  # GET /receipts/1.pdf
  def show
    @address = @receipt.address
    @account = current_user.accounts.find(@receipt.account_id)

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @receipt }
      format.pdf {
        @pdf = ReceiptPDF.new(@receipt).render
        send_data @pdf, type: 'application/pdf', disposition: 'inline'
      }
    end
  end

  # GET /receipts/new
  def new
    # Set the number of the document
    last_issued = current_user.receipts.income.try(:last).try(:number)
    @next_income = ::InvoiceBar::Sequence.new(from: last_issued, format: ['VD', :year, :month]).nextn(by: :month)
    last_received = current_user.receipts.expense.try(:last).try(:number)
    @next_expense = ::InvoiceBar::Sequence.new(from: last_received, format: ['PD', :year, :month]).nextn(by: :month)

    @receipt = Receipt.new
    @receipt.number = @next_income
    @receipt.items.build
    @receipt.build_address
    @receipt.issue_date = Date.today

    respond_on_new @receipt
  end

  def from_template
    @template = current_user.receipt_templates.find(params[:id])
    @receipt = Receipt.from_template(@template)
    @receipt.user_name = current_user.name
    @receipt.user_tax_id = current_user.tax_id
    @receipt.user_tax_id2 = current_user.tax_id2
    @receipt.user_address = current_user.address.copy(
      addressable_type: "Receipt#user_address"
    )

    respond_on_new @receipt
  end

  # POST /receipts/1
  # POST /receipts/1.json
  def create
    flash[:notice], flash[:alert] = nil, nil

    @receipt = Receipt.new(receipt_params)

    apply_templates if params[:fill_in]
    fill_in_contact if params[:fill_in_contact]

    if params[:tax_id]
      if (@receipt.load_contact_from_tax_id(@receipt.contact_tax_id))
        flash[:notice] = I18n.t('messages.tax_id_loaded')
      else
        flash[:alert] = I18n.t('messages.cannot_load_tax_id')
      end
    end

    if params[:fill_in] || params[:fill_in_contact] || params[:tax_id]
      respond_on_new @receipt
    else
      @receipt.user_name = current_user.name
      @receipt.user_tax_id = current_user.tax_id
      @receipt.user_tax_id2 = current_user.tax_id2
      @receipt.user_address = current_user.address.copy(
        addressable_type: "Receipt#user_address"
      )
      current_user.receipts << @receipt
      respond_on_create @receipt
    end
  end

  # GET /receipts/1/edit
  def edit
    respond_on_edit @receipt
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    flash[:notice], flash[:alert] = nil, nil

    apply_templates if params[:fill_in]
    fill_in_contact if params[:fill_in_contact]

    if params[:tax_id]
      if (@receipt.load_contact_from_tax_id(@receipt.contact_tax_id))
        flash[:notice] = I18n.t('messages.tax_id_loaded')
      else
        flash[:alert] = I18n.t('messages.cannot_load_tax_id')
      end
    end

    if params[:fill_in] || params[:fill_in_contact] || params[:tax_id]
      respond_on_edit @receipt
    else
      respond_on_update @receipt, receipt_params
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_on_destroy @receipt, receipts_url
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
      @receipt = current_user.receipts.where(number: params[:number]).first
    end

    def receipt_params
      params.require(:receipt).permit(:number, :sent, :paid,
                                      :amount, :contact_tax_id2, :contact_tax_id, :contact_name, :issue_date, :issuer,
                                      :issuer,
                                      :account_id, :user_id, :note,
                                      address_attributes: [:street, :street_number, :city, :city_part, :postcode, :extra_address_line],
                                      items_attributes: [:id, :name, :number, :price, :unit, :_destroy])
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
