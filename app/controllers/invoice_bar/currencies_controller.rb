# encoding: utf-8

module InvoiceBar
  class CurrenciesController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json

    before_filter :require_admin_rights

    def create
      create! {}
    end

    def update
      update! {}
    end

    def destroy
      destroy! {}
    end

    protected

      def begin_of_association_chain
        # For InheritedResources
        # Currencies are general and not user specific
      end
  end
end
