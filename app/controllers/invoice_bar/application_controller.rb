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

      def fetch_user_contacts
        @contacts = current_user.contacts
      end

      def fetch_user_invoice_templates
        @invoice_templates = current_user.invoice_templates
      end

      def fetch_user_receipt_templates
        @receipt_templates = current_user.receipt_templates
      end

      def fetch_user_accounts
        @accounts = current_user.accounts

        if @accounts.empty?
          flash[:alert] = t('messages.no_accounts')
        end
      end

      def fetch_currencies
        @currencies = Currency.order('priority DESC')

        if @currencies.empty?
          flash[:alert] = t('messages.no_currencies')
        end
      end

      def require_admin_rights
        if current_user
          unless current_user.administrator?
            redirect_to root_url, alert: t('messages.not_administrator')
          end
        else
          not_authenticated
        end
      end

      def not_authenticated
        redirect_to login_url, alert: t('messages.not_authenticated')
      end
  end
end
