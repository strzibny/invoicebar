module InvoiceBar
  class InvoiceTemplatesController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json

    before_filter :require_login
    before_filter :set_user_contacts, only: [:new, :create, :edit, :update]
    before_filter :set_user_accounts, only: [:new, :create, :edit, :update]

    def index
      @invoice_templates = current_user.invoice_templates.page(params[:page])

      index! {}
    end

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

    def new
      @invoice_template = InvoiceTemplate.new
      @invoice_template.items.build
      @invoice_template.build_address

      new!
    end

    def create
      flash[:notice], flash[:alert] = nil, nil

      @invoice_template = InvoiceTemplate.new(params[:invoice_template])

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

        create! {}
      end
    end

    def edit
      @invoice_template = InvoiceTemplate.find(params[:id])
      @invoice_template.build_address unless @invoice_template.address

      edit!
    end

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
        update! {}
      end
    end

    def destroy
      destroy! {}
    end

    protected

      def collection
        @invoice_templates ||= end_of_association_chain.page(params[:page])
      end

      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @invoice_template.use_contact(contact)
        end
      end
  end
end
