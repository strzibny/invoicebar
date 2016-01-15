require 'test_helper'

class InvoiceBar::API::ReceiptsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Engine.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @receipt = FactoryGirl.create(:invoice_bar_receipt, user: @user, account: @account)

    login_user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@receipt].to_json, response.body
  end

  test "should create receipt" do
    @new_receipt = FactoryGirl.build(:invoice_bar_receipt, user: @user, account: @account)

    assert_difference('InvoiceBar::Receipt.count') do
      post :create, format: :json, receipt: {
        number: @new_receipt.number,
        contact_name: @new_receipt.contact_name,
        contact_ic: @new_receipt.contact_ic,
        contact_dic: @new_receipt.contact_dic,
        issue_date: @new_receipt.issue_date,
        account_id: @new_receipt.account_id,
        user_id: @new_receipt.user_id }
    end

    assert_equal 201, response.status
  end

  test "should show receipt" do
    get :show, format: :json, id: @receipt
    assert_equal 200, response.status
    assert_equal @receipt.to_json, response.body
  end

  test "should update receipt" do
    put :update, format: :json, id: @receipt, receipt: {
      number: '12345',
      contact_name: @receipt.contact_name,
      contact_ic: @receipt.contact_ic,
      contact_dic: @receipt.contact_dic,
      issue_date: @receipt.issue_date,
      account_id: @receipt.account_id,
      user_id: @receipt.user_id }

    assert_equal 200, response.status

    @receipt = InvoiceBar::Receipt.find(@receipt.id)
    assert_equal '12345', @receipt.number
  end

  test "should destroy receipt" do
    assert_difference('InvoiceBar::Receipt.count', -1) do
      delete :destroy, format: :json, id: @receipt
    end

    assert_equal 200, response.status
  end
end
