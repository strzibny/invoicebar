module InvoiceBar
  class AccountsController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :fetch_currencies, only: [:new, :create, :edit, :update]
    before_action :set_account, only: [:show, :edit, :update, :destroy]

    # GET /accounts
    # GET /accounts.json
    def index
      @accounts = current_user.accounts.page(params[:page])
    end

    # GET /accounts/1
    # GET /accounts/1.json
    def show
    end

    # GET /accounts/new
    def new
      @account = InvoiceBar::Account.new
    end

    # GET /accounts/1/edit
    def edit
    end

    # account /accounts
    # account /accounts.json
    def create
      @account = InvoiceBar::Account.new(account_params)
      current_user.accounts << @account

      respond_to do |format|
        if @account.save
          format.html { redirect_to @account, notice: 'Account was successfully created.' }
          format.json { render :show, status: :created, location: @account }
        else
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /accounts/1
    # PATCH/PUT /accounts/1.json
    def update
      respond_to do |format|
        if @account.update(account_params)
          format.html { redirect_to @account, notice: 'Account was successfully updated.' }
          format.json { render :show, status: :ok, location: @account }
        else
          format.html { render :edit }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /accounts/1
    # DELETE /accounts/1.json
    def destroy
      @account.destroy
      respond_to do |format|
        format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
        format.json { head :no_content }
      end
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
