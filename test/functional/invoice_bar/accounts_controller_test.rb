require 'test_helper'

class InvoiceBar::AccountsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Engine.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)

    login_user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    @new_account = FactoryGirl.build(:invoice_bar_account, name: 'Account', user: @user)

    assert_difference('InvoiceBar::Account.count') do
      post :create, account: {
        name:                @new_account.name,
        amount:              @new_account.amount,
        bank_account_number: @new_account.bank_account_number,
        iban:                @new_account.iban,
        swift:               @new_account.swift,
        currency_id:         @new_account.currency_id,
        user_id:             @new_account.user_id }
    end
  end

  test "should show account" do
    get :show, id: @account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account
    assert_response :success
  end

  test "should update account" do
    put :update, id: @account, account: {
      name:                @account.name,
      amount:              @account.amount,
      bank_account_number: @account.bank_account_number,
      iban:                @account.iban,
      swift:               @account.swift,
      currency_id:         @account.currency_id,
      user_id:             @account.user_id }
  end

  test "should destroy account" do
    assert_difference('InvoiceBar::Account.count', -1) do
      delete :destroy, id: @account
    end
  end
end
