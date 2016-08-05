module InvoiceBar
  class ReceiptTemplatesController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :set_user_contacts, only: [:new, :create, :edit, :update]
    before_action :set_user_accounts, only: [:new, :create, :edit, :update]
    before_action :set_receipt_template, only: [:show, :edit, :update, :destroy]

    # GET /receipt_templates
    # GET /receipt_templates.json
    def index
      @receipt_templates = current_user.receipt_templates.page(params[:page])
      respond_on_index @receipt_templates
    end

    # GET /receipt_templates/1
    # GET /receipt_templates/1.json
    def show
      @address = @receipt_template.address

      unless @receipt_template.account_id or current_user.accounts
        @account = current_user.accounts.find(@receipt_template.account_id)
      end

      respond_on_show @receipt_template
    end

    # GET /receipt_templates/new
    def new
      @receipt_template = ReceiptTemplate.new
      @receipt_template.items.build
      @receipt_template.build_address
      respond_on_new @receipt_template
    end

    # POST /receipt_templates/1
    # POST /receipt_templates/1.json
    def create
      flash[:notice], flash[:alert] = nil, nil

      @receipt_template = ReceiptTemplate.new(receipt_template_params)

      fill_in_contact if params[:fill_in_contact]

      if params[:tax_id]
        if (@receipt_template.load_contact_from_tax_id(@receipt_template.contact_tax_id))
          flash[:notice] = I18n.t('messages.tax_id_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_tax_id')
        end
      end

      if params[:fill_in_contact] || params[:tax_id]
        respond_on_new @receipt_template
      else
        current_user.receipt_templates << @receipt_template
        respond_on_create @receipt_template
      end
    end

    # GET /invoice_receipts/1/edit
    def edit
      @receipt_template.build_address unless @receipt_template.address
      respond_on_edit @receipt_template
    end

    def update
      flash[:notice], flash[:alert] = nil, nil

      fill_in_contact if params[:fill_in_contact]

      if params[:tax_id]
        if (@receipt_template.load_contact_from_tax_id(@receipt_template.contact_tax_id))
          flash[:notice] = I18n.t('messages.tax_id_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_tax_id')
        end
      end

      if params[:fill_in_contact] || params[:tax_id]
        respond_on_edit @receipt_template
      else
        respond_on_update @receipt_template, receipt_template_params
      end
    end

    # DELETE /receipt_templates/1
    # DELETE /receipt_templates/1.json
    def destroy
      @receipt_template.destroy
      respond_on_destroy @receipt_template, receipt_templates_url
    end

    protected

      def set_receipt_template
        @receipt_template = current_user.receipt_templates.find(params[:id])
      end

      def receipt_template_params
        params.require(:receipt_template).permit(:name, :number, :sent, :paid,
                                                 :amount, :contact_tax_id2, :contact_tax_id, :contact_name, :issue_date, :issuer,
                                                 :issuer,
                                                 :account_id, :user_id, :note,
                                                 address_attributes: [:street, :street_number, :city, :city_part, :postcode, :extra_address_line],
                                                 items_attributes: [:id, :name, :number, :price, :unit, :_destroy])
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @receipt_template.use_contact(contact)
        end
      end
  end
end
