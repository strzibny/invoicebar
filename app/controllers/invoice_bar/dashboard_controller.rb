module InvoiceBar
  class DashboardController < InvoiceBar::ApplicationController
    before_action :require_login

    def index
      redirect_to invoices_path
    end
  end
end
