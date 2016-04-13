require 'test_helper'

class InvoiceBar::API::ReceiptTemplatesControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Engine.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @receipt_template = FactoryGirl.create(:invoice_bar_receipt_template, user: @user, account: @account)

    login_user @user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@receipt_template].to_json, response.body
  end

  test "should create receipt_template" do
    @new_receipt_template = FactoryGirl.build(:invoice_bar_receipt_template, user: @user, account: @account, name: 'Another template')

    assert_difference('InvoiceBar::ReceiptTemplate.count') do
      post :create, format: :json, receipt_template: {
        account_id: @new_receipt_template.account_id,
        contact_dic: @new_receipt_template.contact_dic,
        contact_ic: @new_receipt_template.contact_ic,
        contact_name: @new_receipt_template.contact_name,
        issue_date: @new_receipt_template.issue_date,
        name: @new_receipt_template.name }
    end

    assert_equal 201, response.status
  end

  test "should show receipt_template" do
    get :show, format: :json, id: @receipt_template
    assert_equal 200, response.status
    assert_equal @receipt_template.to_json, response.body
  end

  test "should update receipt_template" do
    put :update, format: :json, id: @receipt_template, receipt_template: {
      account_id: @receipt_template.account_id,
      contact_dic: @receipt_template.contact_dic,
      contact_ic: @receipt_template.contact_ic,
      contact_name: 'Updated contact name',
      issue_date: @receipt_template.issue_date,
      name: 'Updated name',
      user_id: @receipt_template.user_id }

    assert_equal 200, response.status

    @receipt_template = InvoiceBar::ReceiptTemplate.find(@receipt_template.id)
    assert_equal 'Updated contact name', @receipt_template.contact_name
    assert_equal 'Updated name', @receipt_template.name
  end

  test "should destroy receipt_template" do
    assert_difference('InvoiceBar::ReceiptTemplate.count', -1) do
      delete :destroy, format: :json, id: @receipt_template
    end

    assert_equal 200, response.status
  end
end
