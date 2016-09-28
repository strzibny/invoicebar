require 'test_helper'

class API::AccountsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)

    login_user @user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@account].to_json, response.body
  end

  test "should create account" do
    @new_account = FactoryGirl.build(:invoice_bar_account, name: 'Account', user: @user)

    assert_difference('Account.count') do
      post :create, format: :json, account: {
        name:                @new_account.name,
        amount:              @new_account.amount,
        bank_account_number: @new_account.bank_account_number,
        iban:                @new_account.iban,
        swift:               @new_account.swift,
        currency_id:         @new_account.currency_id,
        user_id:             @new_account.user_id }
    end

    assert_equal 201, response.status
  end

  test "should show account" do
    get :show, format: :json, id: @account
    assert_equal 200, response.status
    assert_equal @account.to_json, response.body
  end

  test "should update account" do
    post :update, format: :json, id: @account, account: {
      name:                'Updated account',
      amount:              1_000_000,
      bank_account_number: @account.bank_account_number,
      iban:                @account.iban,
      swift:               @account.swift,
      currency_id:         @account.currency_id,
      user_id:             @account.user_id }

    assert_equal 200, response.status

    @account = Account.find(@account.id)
    assert_equal 'Updated account', @account.name
    assert_equal 1_000_000, @account.amount
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      post :destroy, format: :json, id: @account
    end

    assert_equal 200, response.status
  end

end
