require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @account = FactoryGirl.create(:invoice_bar_account, user: @user)
    @invoice = FactoryGirl.create(:invoice_bar_invoice, user: @user, account: @account)

    login_user @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    @new_invoice = FactoryGirl.build(:invoice_bar_invoice, user: @user, account: @account)

    assert_difference('Invoice.count') do
      post :create, invoice: {
        number: @new_invoice.number,
        amount: @new_invoice.amount,
        contact_name: @new_invoice.contact_name,
        contact_tax_id: @new_invoice.contact_tax_id,
        contact_tax_id2: @new_invoice.contact_tax_id2,
        due_date: @new_invoice.due_date,
        issue_date: @new_invoice.issue_date,
        payment_identification_number: @new_invoice.payment_identification_number,
        sent: @new_invoice.sent,
        paid: @new_invoice.paid,
        account_id: @new_invoice.account_id,
        user_id: @new_invoice.user_id,
        address_attributes: {
          street: @new_invoice.address.street,
          street_number: @new_invoice.address.street_number,
          postcode: @new_invoice.address.postcode,
          city: @new_invoice.address.city,
          city_part: @new_invoice.address.city_part,
          extra_address_line: @new_invoice.address.extra_address_line }}
    end
  end

  test "should show invoice" do
    get :show, number: @invoice.number
    assert_response :success
  end

  test "should get edit" do
    get :edit, number: @invoice.number
    assert_response :success
  end

  test "should update invoice" do
    put :update, number: @invoice.number, invoice: {
      number: @invoice.number,
      amount: @invoice.amount,
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
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, number: @invoice.number
    end
  end
end
