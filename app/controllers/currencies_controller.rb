class CurrenciesController < ApplicationController
  before_action :require_admin_rights
  before_action :set_currency, only: [:show, :edit, :update, :destroy]

  # GET /currencies
  # GET /currencies.json
  def index
    @currencies = Currency.all.page(params[:page])
    respond_on_index @currencies
  end

  # GET /currencies/1
  # GET /currencies/1.json
  def show
    respond_on_show @currency
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
    respond_on_new @currency
  end

  # GET /currencies/1/edit
  def edit
  end

  # POST /currencies
  # POST /currencies.json
  def create
    @currency = Currency.new(currency_params)
    respond_on_create @currency
  end

  # PATCH/PUT /currencies/1
  # PATCH/PUT /currencies/1.json
  def update
    respond_on_update @currency, currency_params
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    @currency.destroy
    respond_on_destroy @currency, currency_url
  end

  private

    def set_currency
      @currency = Currency.find(params[:id])
    end

    def currency_params
      params.require(:currency).permit(:name, :symbol, :priority)
    end
end
