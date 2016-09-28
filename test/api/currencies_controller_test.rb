require 'test_helper'

class API::CurrenciesControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user, administrator: true)
    @contact = FactoryGirl.create(:invoice_bar_contact, user: @user)

    login_user @user

    @currency = FactoryGirl.create(:invoice_bar_currency)
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@currency].to_json, response.body
  end

  test "should create currency" do
    @new_currency = FactoryGirl.build(:invoice_bar_currency, name: 'Dollars', symbol: '$')

    assert_difference('Currency.count') do
      post :create, format: :json, currency: {
        name: @new_currency.name,
        symbol: @new_currency.symbol,
        priority: @new_currency.priority }
    end

    assert_equal 201, response.status
  end

  test "should show currency" do
    get :show, format: :json, id: @currency
    assert_equal 200, response.status
    assert_equal @currency.to_json, response.body
  end

  test "should update currency" do
    put :update, format: :json, id: @currency, currency: {
      name: 'New Currency',
      symbol: 'NC',
      priority: @currency.priority }

    assert_equal 200, response.status

    @currency = Currency.find(@currency.id)
    assert_equal 'New Currency', @currency.name
    assert_equal 'NC', @currency.symbol
  end

  test "should destroy currency" do
    assert_difference('Currency.count', -1) do
      delete :destroy, format: :json, id: @currency
    end

    assert_equal 200, response.status
  end
end
