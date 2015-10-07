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
    end

    # GET /receipt_templates/1
    # GET /receipt_templates/1.json
    def show
      @receipt_template = current_user.receipt_templates.find(params[:id])
      @address = @receipt_template.address
      @account = current_user.accounts.find(@receipt_template.account_id) unless @receipt_template.account_id or current_user.accounts

      respond_to do |format|
        format.html
        format.pdf
        format.json { render json: @receipt_template }
      end
    end

    # GET /receipt_templates/new
    def new
      @receipt_template = ReceiptTemplate.new
      @receipt_template.items.build
      @receipt_template.build_address

      respond_to do |format|
        format.html
      end
    end

    # POST /receipt_templates/1
    # POST /receipt_templates/1.json
    def create
      flash[:notice], flash[:alert] = nil, nil

      @receipt_template = ReceiptTemplate.new(receipt_template_params)

      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@receipt_template.load_contact_from_ic(@receipt_template.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in_contact] || params[:ic]
        respond_to do |format|
          format.html { render action: 'new' }
          format.json { render json: @receipt_template }
        end
      else
        current_user.receipt_templates << @receipt_template

        respond_to do |format|
          if @receipt_template.save
            format.html { redirect_to @receipt_template, notice: 'Receipt template was successfully created.' }
            format.json { render :show, status: :created, location: @receipt_template }
          else
            format.html { render :new }
            format.json { render json: @receipt_template.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    # GET /invoice_receipts/1/edit
    def edit
      @receipt_template = ReceiptTemplate.find(params[:id])
      @receipt_template.build_address unless @receipt_template.address

      respond_to do |format|
        format.html
      end
    end

    def update
      flash[:notice], flash[:alert] = nil, nil

      @receipt_template = current_user.receipt_templates.find(params[:id])

      fill_in_contact if params[:fill_in_contact]

      if params[:ic]
        if (@receipt_template.load_contact_from_ic(@receipt_template.contact_ic))
          flash[:notice] = I18n.t('messages.ic_loaded')
        else
          flash[:alert] = I18n.t('messages.cannot_load_ic')
        end
      end

      if params[:fill_in_contact] || params[:ic]
        respond_to do |format|
          format.html { render action: 'edit' }
          format.json { render json: @receipt_template }
        end
      else
        respond_to do |format|
          if @receipt_template.update(receipt_template_params)
            format.html { redirect_to @receipt_template, notice: 'Receipt template was successfully updated.' }
            format.json { render :show, status: :ok, location: @receipt_template }
          else
            format.html { render :edit }
            format.json { render json: @receipt_template.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    # DELETE /receipt_templates/1
    # DELETE /receipt_templates/1.json
    def destroy
      @receipt_template.destroy
      respond_to do |format|
        format.html { redirect_to contacts_url, notice: 'Receipt template was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    protected

      def set_receipt_template
        @receipt_template = InvoiceBar::ReceiptTemplate.find(params[:id])
      end

      def receipt_template_params
        params.require(:receipt_template).permit(:name, :number, :sent, :paid,
                                                 :amount, :contact_dic, :contact_ic, :contact_name, :issue_date, :issuer,
                                                 :issuer,
                                                 :account_id, :user_id, :address, :address_attributes, :items_attributes)
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @receipt_template.use_contact(contact)
        end
      end
  end
end
