module InvoiceBar
  class CurrenciesController < InvoiceBar::ApplicationController
    before_action :require_admin_rights
    before_action :set_currency, only: [:show, :edit, :update, :destroy]

    # GET /currencies
    # GET /currencies.json
    def index
      @currencies = InvoiceBar::Currency.all.page(params[:page])
    end

    # GET /currencies/1
    # GET /currencies/1.json
    def show
    end

    # GET /currencies/new
    def new
      @currency = InvoiceBar::Currency.new
    end

    # GET /currencies/1/edit
    def edit
    end

    # POST /currencies
    # POST /currencies.json
    def create
      @currency = InvoiceBar::Currency.new(currency_params)

      respond_to do |format|
        if @currency.save
          format.html { redirect_to @currency, notice: 'Currency was successfully created.' }
          format.json { render :show, status: :created, location: @currency }
        else
          format.html { render :new }
          format.json { render json: @currency.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /currencies/1
    # PATCH/PUT /currencies/1.json
    def update
      respond_to do |format|
        if @currency.update(currency_params)
          format.html { redirect_to @currency, notice: 'Currency was successfully updated.' }
          format.json { render :show, status: :ok, location: @currency }
        else
          format.html { render :edit }
          format.json { render json: @currency.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /currencies/1
    # DELETE /currencies/1.json
    def destroy
      @currency.destroy
      respond_to do |format|
        format.html { redirect_to currencies_url, notice: 'Currency was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

      def set_currency
        @currency = InvoiceBar::Currency.find(params[:id])
      end

      def currency_params
        params.require(:currency).permit(:name, :symbol, :priority)
      end
  end
end
