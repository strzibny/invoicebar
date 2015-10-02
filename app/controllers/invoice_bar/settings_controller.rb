module InvoiceBar
  class SettingsController < InvoiceBar::ApplicationController

    before_filter :require_login

    def index
      @user = current_user
    end
  end
end
