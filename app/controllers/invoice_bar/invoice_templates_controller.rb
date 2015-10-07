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

    end

    # GET /invoice_templates/1
    # GET /invoice_templates/1.json
    def show
      @invoice_template = current_user.invoice_templates.find(params[:id])
      @address = @invoice_template.address
      @account = current_user.accounts.find(@invoice_template.account_id) unless @invoice_template.account_id or current_user.accounts

      respond_to do |format|
        format.html
        format.pdf
        format.json { render json: @invoice_template }
      end
    end

    # GET /invoice_templates/new
    def new
      @invoice_template = InvoiceTemplate.new
      @invoice_template.items.build
      @invoice_template.build_address

      respond_to do |format|
        format.html
      end
    end

    # POST /invoice_templates/1
    # POST /invoice_templates/1.json
    def create
      flash[:notice], flash[:alert] = nil, nil

      @invoice_template = InvoiceTemplate.new(invoice_template_params)

      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@invoice_template.load_contact_from_ic(@invoice_template.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in_contact] || params[:ic]
        respond_to do |format|
          format.html { render action: 'new' }
          format.json { render json: @invoice_template }
        end
      else
        current_user.invoice_templates << @invoice_template

        respond_to do |format|
          if @invoice_template.save
            format.html { redirect_to @invoice_template, notice: 'Invoice template was successfully created.' }
            format.json { render :show, status: :created, location: @invoice_template }
          else
            format.html { render :new }
            format.json { render json: @invoice_template.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    # GET /invoice_templates/1/edit
    def edit
      @invoice_template = InvoiceTemplate.find(params[:id])
      @invoice_template.build_address unless @invoice_template.address

      respond_to do |format|
        format.html
      end
    end

    # PATCH/PUT /invoices/1
    # PATCH/PUT /invoices/1.json
    def update
      flash[:notice], flash[:alert] = nil, nil

      @invoice_template = current_user.invoice_templates.find(params[:id])

      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@invoice_template.load_contact_from_ic(@invoice_template.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in_contact] || params[:ic]
        respond_to do |format|
          format.html { render action: 'edit' }
          format.json { render json: @invoice_template }
        end
      else
        respond_to do |format|
          if @invoice_template.update(invoice_template_params)
            format.html { redirect_to @invoice_template, notice: 'Invoice template was successfully updated.' }
            format.json { render :show, status: :ok, location: @invoice_template }
          else
            format.html { render :edit }
            format.json { render json: @invoice_template.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    # DELETE /invoice_templates/1
    # DELETE /invoice_templates/1.json
    def destroy
      @invoice_template.destroy
      respond_to do |format|
        format.html { redirect_to contacts_url, notice: 'Invoice template was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    protected

      def set_invoice_template
        @invoice_template = InvoiceBar::InvoiceTemplate.find(params[:id])
      end

      def invoice_template_params
        params.require(:invoice_template).permit(:name, :number, :sent, :paid,
                                                 :amount, :contact_dic, :contact_ic, :contact_name, :issue_date, :issuer,
                                                 :due_date, :payment_identification_number, :issuer,
                                                 :account_id, :user_id, :address, :address_attributes, :items_attributes)
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @invoice_template.use_contact(contact)
        end
      end
  end
end
