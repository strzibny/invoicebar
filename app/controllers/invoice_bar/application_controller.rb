module InvoiceBar
  class ApplicationController < ActionController::Base
    protect_from_forgery

    helper InvoiceBar::InvoiceBarHelper
    layout 'invoice_bar/layouts/signed_in'

    protected

      # For InheritedResources
      def begin_of_association_chain
        current_user
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
