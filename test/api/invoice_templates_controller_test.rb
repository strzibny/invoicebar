require 'test_helper'

class API::InvoiceTemplatesControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @invoice_template = FactoryGirl.create(:invoice_bar_invoice_template, user: @user, account: @account)

    login_user @user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@invoice_template].to_json, response.body
  end

  test "should create invoice_template" do
    @new_invoice_template = FactoryGirl.build(:invoice_bar_invoice_template, user: @user, account: @account, name: 'Another template')

    assert_difference('InvoiceTemplate.count') do
      post :create, format: :json, invoice_template: {
        account_id: @new_invoice_template.account_id,
        contact_tax_id2: @new_invoice_template.contact_tax_id2,
        contact_tax_id: @new_invoice_template.contact_tax_id,
        contact_name: @new_invoice_template.contact_name,
        due_date: @new_invoice_template.due_date,
        issue_date: @new_invoice_template.issue_date,
        name: @new_invoice_template.name,
        payment_identification_number: @new_invoice_template.payment_identification_number }
    end

    assert_equal 201, response.status
  end

  test "should show invoice_template" do
    get :show, format: :json, id: @invoice_template
    assert_equal 200, response.status
    assert_equal @invoice_template.to_json, response.body
  end

  test "should update invoice_template" do
    puts @invoice_template.inspect
    put :update, format: :json, id: @invoice_template, invoice_template: {
      account_id: @invoice_template.account_id,
      contact_tax_id2: @invoice_template.contact_tax_id2,
      contact_tax_id: @invoice_template.contact_tax_id,
      contact_name: 'Updated contact name',
      due_date: @invoice_template.due_date,
      issue_date: @invoice_template.issue_date,
      name: 'Updated name',
      payment_identification_number: @invoice_template.payment_identification_number,
      user_id: @invoice_template.user_id }

    assert_equal 200, response.status

    @invoice_template = InvoiceTemplate.find(@invoice_template.id)
    assert_equal 'Updated contact name', @invoice_template.contact_name
    assert_equal 'Updated name', @invoice_template.name
  end

  test "should destroy invoice_template" do
    assert_difference('InvoiceTemplate.count', -1) do
      delete :destroy, format: :json, id: @invoice_template
    end

    assert_equal 200, response.status
  end
end
