# encoding: utf-8

module InvoiceBar
  class DashboardController < InvoiceBar::ApplicationController
    before_filter :require_login

    def index
      @accounts = current_user.accounts
    end
  end
end
