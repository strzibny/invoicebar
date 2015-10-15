module InvoiceBar
  class SettingsController < InvoiceBar::ApplicationController
    before_action :require_login

    def index
      @user = current_user
    end
  end
end
