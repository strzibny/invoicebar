module InvoiceBar
  class SessionsController < InvoiceBar::ApplicationController
    layout 'invoice_bar/layouts/signed_out'

    before_action :require_login_from_http_basic, only: [:login_from_http_basic]

    # Log in form
    def new
      respond_on_new @session
    end

    # Log the user in
    def create
      user = login(params[:email], params[:password], params[:remember_me])

      if user
        redirect_back_or_to root_url
      else
        flash[:error] =  t('messages.cannot_log_in')

        respond_on_create @session
      end
    end

    # Log out
    def destroy
      logout

      redirect_to root_url, notice: t('messages.logged_out')
    end

    def login_from_http_basic
      redirect_to root_path
    end
  end
end
