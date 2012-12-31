# encoding: utf-8

module InvoiceBar
  class ReceiptTemplatesController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json
    
    before_filter :require_login
    before_filter :fetch_user_contacts, :only => [:new, :create, :edit, :update]
    before_filter :fetch_user_accounts, :only => [:new, :create, :edit, :update]

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

    def new
      @receipt_template = ReceiptTemplate.new
      @receipt_template.items.build
      @receipt_template.build_address

      new!
    end

    def create
      flash[:notice], flash[:alert] = nil, nil
      
      @receipt_template = ReceiptTemplate.new(params[:receipt_template])
    
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
      
        create! {}
      end
    end
  
    def edit
      @receipt_template = ReceiptTemplate.find(params[:id])
      @receipt_template.build_address unless @receipt_template.address
    
      edit!
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
        update! {}
      end
    end
    
    def destroy
      destroy! {}
    end
  
    protected
  
      def collection
        @receipt_templates ||= end_of_association_chain.page(params[:page])
      end
      
      def fill_in_contact
        if params[:contact_id] and not params[:contact_id].blank?
          contact = current_user.contacts.find(params[:contact_id])
          @receipt_template.use_contact(contact)
        end
      end
  end
end