require 'test_helper'

class InvoiceBar::API::InvoicesControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Engine.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @invoice = FactoryGirl.create(:invoice_bar_invoice, user: @user, account: @account)

    login_user @user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@invoice].to_json, response.body
  end

  test "should create invoice" do
    @new_invoice = FactoryGirl.build(:invoice_bar_invoice, user: @user, account: @account)

    assert_difference('InvoiceBar::Invoice.count') do
      post :create, format: :json, invoice: {
        number: @new_invoice.number,
        contact_name: @new_invoice.contact_name,
        contact_tax_id: @new_invoice.contact_tax_id,
        contact_tax_id2: @new_invoice.contact_tax_id2,
        due_date: @new_invoice.due_date,
        issue_date: @new_invoice.issue_date,
        payment_identification_number: @new_invoice.payment_identification_number,
        sent: @new_invoice.sent,
        paid: @new_invoice.paid,
        account_id: @new_invoice.account_id,
        user_id: @new_invoice.user_id }
    end

    assert_equal 201, response.status
  end

  test "should show invoice" do
    get :show, format: :json, number: @invoice.number
    assert_equal 200, response.status
    assert_equal @invoice.to_json, response.body
  end

  test "should update invoice" do
    put :update, format: :json, number: @invoice.number, invoice: {
      number: '12345',
      contact_name: @invoice.contact_name,
      contact_tax_id: @invoice.contact_tax_id,
      contact_tax_id2: @invoice.contact_tax_id2,
      due_date: @invoice.due_date,
      issue_date: @invoice.issue_date,
      payment_identification_number: @invoice.payment_identification_number,
      sent: @invoice.sent,
      paid: @invoice.paid,
      account_id: @invoice.account_id,
      user_id: @invoice.user_id }

    assert_equal 200, response.status

    @invoice = InvoiceBar::Invoice.find(@invoice.id)
    assert_equal '12345', @invoice.number
  end

  test "should destroy invoice" do
    assert_difference('InvoiceBar::Invoice.count', -1) do
      delete :destroy, format: :json, number: @invoice.number
    end

    assert_equal 200, response.status
  end
end
