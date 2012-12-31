# encoding: utf-8

module InvoiceBar
  class DashboardController < InvoiceBar::ApplicationController
    before_filter :require_login
    
    def index
      redirect_to invoices_path
    end
  end
end