require 'test_helper'

class InvoiceBar::API::ContactsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Engine.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @contact = FactoryGirl.create(:invoice_bar_contact, user: @user)

    login_user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@contact].to_json, response.body
  end

  test "should create contact" do
    @new_contact = FactoryGirl.build(:invoice_bar_contact, user: @user)

    assert_difference('InvoiceBar::Contact.count') do
      post :create, format: :json, contact: {
        name:         @new_contact.name,
        ic:           @new_contact.ic,
        dic:          @new_contact.dic,
        email:        @new_contact.email,
        phone:        @new_contact.phone,
        web:          @new_contact.web,
        bank_account: @new_contact.bank_account,
        user_id:      @new_contact.user_id }
    end

    assert_equal 201, response.status
  end

  test "should show contact" do
    get :show, format: :json, id: @contact
    assert_equal 200, response.status
    assert_equal @contact.to_json, response.body
  end

  test "should update contact" do
    put :update, format: :json, id: @contact, contact: {
      name:         'Updated contact',
      ic:           999_112_58,
      dic:          @contact.dic,
      email:        @contact.email,
      phone:        @contact.phone,
      web:          @contact.web,
      bank_account: @contact.bank_account,
      user_id:      @contact.user_id }

    assert_equal 200, response.status

    @contact = InvoiceBar::Contact.find(@contact.id)
    assert_equal 'Updated contact', @contact.name
    assert_equal 999_112_58, @contact.ic
  end

  test "should destroy contact" do
    assert_difference('InvoiceBar::Contact.count', -1) do
      delete :destroy, format: :json, id: @contact
    end

    assert_equal 200, response.status
  end
end
