module InvoiceBar
  class AccountsController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :set_currencies, only: [:new, :create, :edit, :update]
    before_action :set_account, only: [:show, :edit, :update, :destroy]

    # GET /accounts
    # GET /accounts.json
    def index
      @accounts = current_user.accounts.page(params[:page])
      respond_on_index @accounts
    end

    # GET /accounts/1
    # GET /accounts/1.json
    def show
      respond_on_show @account
    end

    # GET /accounts/new
    def new
      @account = InvoiceBar::Account.new
      respond_on_new @account
    end

    # GET /accounts/1/edit
    def edit
      respond_on_edit @account
    end

    # POST /accounts
    # POST /accounts.json
    def create
      @account = InvoiceBar::Account.new(account_params)
      current_user.accounts << @account
      respond_on_create @account
    end

    # PATCH/PUT /accounts/1
    # PATCH/PUT /accounts/1.json
    def update
      respond_on_update @account, account_params
    end

    # DELETE /accounts/1
    # DELETE /accounts/1.json
    def destroy
      @account.destroy
      respond_on_destroy @account, account_url
    end

    private

      def set_account
        @account = InvoiceBar::Account.find(params[:id])
      end

      def account_params
        params.require(:account).permit(:amount, :bank_account_number, :iban,
                                        :name, :swift, :user_id, :currency_id)
      end
  end
end
