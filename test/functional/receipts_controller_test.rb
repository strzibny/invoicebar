require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @receipt = FactoryGirl.create(:invoice_bar_receipt, user: @user, account: @account)

    login_user @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receipt" do
    @new_receipt = FactoryGirl.build(:invoice_bar_receipt, user: @user, account: @account)

    assert_difference('Receipt.count') do
      post :create, receipt: {
        number: @new_receipt.number,
        amount: @new_receipt.amount,
        contact_name: @new_receipt.contact_name,
        contact_tax_id: @new_receipt.contact_tax_id,
        contact_tax_id2: @new_receipt.contact_tax_id2,
        issue_date: @new_receipt.issue_date,
        account_id: @new_receipt.account_id,
        user_id: @new_receipt.user_id,
        address_attributes: {
          street: @new_receipt.address.street,
          street_number: @new_receipt.address.street_number,
          postcode: @new_receipt.address.postcode,
          city: @new_receipt.address.city,
          city_part: @new_receipt.address.city_part,
          extra_address_line: @new_receipt.address.extra_address_line }}
    end
  end

  test "should show receipt" do
    get :show, number: @receipt.number
    assert_response :success
  end

  test "should get edit" do
    get :edit, number: @receipt.number
    assert_response :success
  end

  test "should update receipt" do
    put :update, number: @receipt.number, receipt: {
      number: @receipt.number,
      amount: @receipt.amount,
      contact_name: @receipt.contact_name,
      contact_tax_id: @receipt.contact_tax_id,
      contact_tax_id2: @receipt.contact_tax_id2,
      issue_date: @receipt.issue_date,
      account_id: @receipt.account_id,
      user_id: @receipt.user_id }
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete :destroy, number: @receipt.number
    end
  end
end
