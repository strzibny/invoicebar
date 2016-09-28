require 'test_helper'

class InvoiceTemplatesControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @invoice_template = FactoryGirl.create(:invoice_bar_invoice_template, user: @user, account: @account)

    login_user @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoice_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice_template" do
    @new_invoice_template = FactoryGirl.build(:invoice_bar_invoice_template, user: @user, account: @account, name: 'Another template')

    assert_difference('InvoiceTemplate.count') do
      post :create, invoice_template: {
        account_id: @new_invoice_template.account_id,
        amount: @new_invoice_template.amount,
        contact_tax_id2: @new_invoice_template.contact_tax_id2,
        contact_tax_id: @new_invoice_template.contact_tax_id,
        contact_name: @new_invoice_template.contact_name,
        due_date: @new_invoice_template.due_date,
        issue_date: @new_invoice_template.issue_date,
        name: @new_invoice_template.name,
        payment_identification_number: @new_invoice_template.payment_identification_number }
    end
  end

  test "should show invoice_template" do
    get :show, id: @invoice_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice_template
    assert_response :success
  end

  test "should update invoice_template" do
    put :update, id: @invoice_template, invoice_template: {
      account_id: @invoice_template.account_id,
      amount: @invoice_template.amount,
      contact_tax_id2: @invoice_template.contact_tax_id2,
      contact_tax_id: @invoice_template.contact_tax_id,
      contact_name: @invoice_template.contact_name,
      due_date: @invoice_template.due_date,
      issue_date: @invoice_template.issue_date,
      name: @invoice_template.name,
      payment_identification_number: @invoice_template.payment_identification_number,
      user_id: @invoice_template.user_id }
  end

  test "should destroy invoice_template" do
    assert_difference('InvoiceTemplate.count', -1) do
      delete :destroy, id: @invoice_template
    end
  end
end
