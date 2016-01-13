module InvoiceBar
  class ApplicationController < ActionController::Base
    protect_from_forgery

    helper InvoiceBar::InvoiceBarHelper
    layout 'invoice_bar/layouts/signed_in'

    protected
      def respond_on_index(collection)
        respond_to do |format|
          format.html { render :index }
          format.json { render json: collection }
        end
      end

      def respond_on_show(object)
        respond_to do |format|
          format.html { render :show }
          format.json { render json: object }
        end
      end

      def respond_on_new(object)
        respond_to do |format|
          format.html { render :new }
        end
      end

      def respond_on_create(object)
        respond_to do |format|
          if object.save
            format.html { redirect_to object }
            format.json { render json: object, status: :created, location: object }
          else
            format.html { render :new }
            format.json { render json: object.errors, status: :unprocessable_entity }
          end
        end
      end

      def respond_on_edit(object)
        respond_to do |format|
          format.html { render :edit }
        end
      end

      def respond_on_update(object, object_params)
        respond_to do |format|
          if object.update(object_params)
            format.html { redirect_to object }
            format.json { render json: object, status: 200, location: object }
          else
            format.html { render :edit }
            format.json { render json: object.errors, status: :unprocessable_entity }
          end
        end
      end

      def respond_on_destroy(object, redirect_url)
        respond_to do |format|
          format.html { redirect_to redirect_url }
          format.json { head :ok }
        end
      end

      def set_user_contacts
        @contacts = current_user.contacts
      end

      def set_user_invoice_templates
        @invoice_templates = current_user.invoice_templates
      end

      def set_user_receipt_templates
        @receipt_templates = current_user.receipt_templates
      end

      def set_user_accounts
        @accounts = current_user.accounts
        flash[:alert] = t('messages.no_accounts') if @accounts.empty?
      end

      def set_currencies
        @currencies = Currency.order('priority DESC')
        flash[:alert] = t('messages.no_currencies') if @currencies.empty?
      end

      def require_admin_rights
        return not_authenticated unless current_user

        unless current_user.administrator?
          redirect_to root_url, alert: t('messages.not_administrator')
        end
      end

      def not_authenticated
        redirect_to login_url, alert: t('messages.not_authenticated')
      end
  end
end
