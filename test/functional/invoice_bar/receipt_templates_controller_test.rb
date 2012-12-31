# encoding: utf-8

require 'test_helper'

class InvoiceBar::ReceiptTemplatesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, :user => @user)
    @receipt_template = FactoryGirl.create(:invoice_bar_receipt_template, :user => @user, :account => @account)
    
    login_user
  end

  test "should get index" do
    get :index, use_route: :invoice_bar
    assert_response :success
    assert_not_nil assigns(:receipt_templates)
  end

  test "should get new" do
    get :new, use_route: :invoice_bar
    assert_response :success
  end

  test "should create receipt_template" do
    @new_receipt_template = FactoryGirl.build(:invoice_bar_receipt_template, :user => @user, :account => @account, :name => 'Another template')
    
    assert_difference('InvoiceBar::ReceiptTemplate.count') do
      post :create, receipt_template: {
        account_id: @new_receipt_template.account_id,
        amount: @new_receipt_template.amount,
        contact_dic: @new_receipt_template.contact_dic,
        contact_ic: @new_receipt_template.contact_ic,
        contact_name: @new_receipt_template.contact_name,
        issue_date: @new_receipt_template.issue_date,
        name: @new_receipt_template.name }, use_route: :invoice_bar
    end
  end

  test "should show receipt_template" do
    get :show, use_route: :invoice_bar, id: @receipt_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, use_route: :invoice_bar, id: @receipt_template
    assert_response :success
  end

  test "should update receipt_template" do
    put :update, id: @receipt_template, receipt_template: {
      account_id: @receipt_template.account_id,
      amount: @receipt_template.amount,
      contact_dic: @receipt_template.contact_dic,
      contact_ic: @receipt_template.contact_ic,
      contact_name: @receipt_template.contact_name,
      issue_date: @receipt_template.issue_date,
      name: @receipt_template.name,
      user_id: @receipt_template.user_id }, use_route: :invoice_bar
  end

  test "should destroy receipt_template" do
    assert_difference('InvoiceBar::ReceiptTemplate.count', -1) do
      delete :destroy, use_route: :invoice_bar, id: @receipt_template
    end
  end
end