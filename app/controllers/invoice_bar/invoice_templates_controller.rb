module InvoiceBar
  class InvoiceTemplatesController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :set_user_contacts, only: [:new, :create, :edit, :update]
    before_action :set_user_accounts, only: [:new, :create, :edit, :update]
    before_action :set_invoice_template, only: [:show, :edit, :update, :destroy]

    # GET /invoice_templates
    # GET /invoice_templates.json
    def index
      @invoice_templates = current_user.invoice_templates.page(params[:page])
      respond_on_index @invoice_templates
    end

    # GET /invoice_templates/1
    # GET /invoice_templates/1.json
    def show
      @address = @invoice_template.address

      unless @invoice_template.account_id or current_user.accounts
        @account = current_user.accounts.find(@invoice_template.account_id)
      end

      respond_on_show @invoice_template
    end

    # GET /invoice_templates/new
    def new
      @invoice_template = InvoiceTemplate.new
      @invoice_template.items.build
      @invoice_template.build_address
      respond_on_new @invoice_template
    end

    # POST /invoice_templates/1
    # POST /invoice_templates/1.json
    def create
      flash[:notice], flash[:alert] = nil, nil

      @invoice_template = InvoiceTemplate.new(invoice_template_params)

      fill_in_contact if params[:fill_in_contact]

      if params[:tax_id]
        if (@invoice_template.load_contact_from_tax_id(@invoice_template.contact_tax_id))
          flash[:notice] = I18n.t('messages.tax_id_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_tax_id')
        end
      end

      if params[:fill_in_contact] || params[:tax_id]
        respond_on_new @invoice_template
      else
        current_user.invoice_templates << @invoice_template
        respond_on_create @invoice_template
      end
    end

    # GET /invoice_templates/1/edit
    def edit
      @invoice_template.build_address unless @invoice_template.address
      respond_on_edit @invoice_template
    end

    # PATCH/PUT /invoices/1
    # PATCH/PUT /invoices/1.json
    def update
      flash[:notice], flash[:alert] = nil, nil

      fill_in_contact if params[:fill_in_contact]

      if params[:tax_id]
        if (@invoice_template.load_contact_from_tax_id(@invoice_template.contact_tax_id))
          flash[:notice] = I18n.t('messages.tax_id_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_tax_id')
        end
      end

      if params[:fill_in_contact] || params[:tax_id]
        respond_on_edit @invoice_template
      else
        respond_on_update @invoice_template, invoice_template_params
      end
    end

    # DELETE /invoice_templates/1
    # DELETE /invoice_templates/1.json
    def destroy
      @invoice_template.destroy
      respond_on_destroy @invoice_template, invoice_templates_url
    end

    protected

      def set_invoice_template
        @invoice_template = current_user.invoice_templates.find(params[:id])
      end

      def invoice_template_params
        params.require(:invoice_template).permit(:name, :number, :sent, :paid,
                                                 :amount, :contact_tax_id2, :contact_tax_id, :contact_name, :issue_date, :issuer,
                                                 :due_date, :payment_identification_number, :issuer,
                                                 :account_id, :user_id,
                                                 address_attributes: [:street, :street_number, :city, :city_part, :postcode, :extra_address_line],
                                                 items_attributes: [:id, :name, :number, :price, :unit, :_destroy])
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @invoice_template.use_contact(contact)
        end
      end
  end
end
