# encoding: utf-8

require 'test_helper'

class InvoiceBar::CurrenciesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:invoice_bar_user, administrator: true)
    @contact = FactoryGirl.create(:invoice_bar_contact, :user => @user)

    login_user

    @currency = FactoryGirl.create(:invoice_bar_currency)
  end

  test "should get index" do
    get :index, use_route: :invoice_bar
    assert_response :success
    assert_not_nil assigns(:currencies)
  end

  test "should get new" do
    get :new, use_route: :invoice_bar
    assert_response :success
  end

  test "should create currency" do
    @new_currency = FactoryGirl.build(:invoice_bar_currency, name: 'Dollars', symbol: '$')

    assert_difference('InvoiceBar::Currency.count') do
      post :create, currency: {
        name: @new_currency.name,
        symbol: @new_currency.symbol,
        priority: @new_currency.priority }, use_route: :invoice_bar
    end
  end

  test "should show currency" do
    get :show, id: @currency, use_route: :invoice_bar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @currency, use_route: :invoice_bar
    assert_response :success
  end

  test "should update currency" do
    put :update, id: @currency, currency: {
      name: @currency.name,
      symbol: @currency.symbol,
      priority: @currency.priority }, use_route: :invoice_bar
  end

  test "should destroy currency" do
    assert_difference('InvoiceBar::Currency.count', -1) do
      delete :destroy, id: @currency, use_route: :invoice_bar
    end
  end
end
