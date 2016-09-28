require 'test_helper'

class API::ContactsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @contact = FactoryGirl.create(:invoice_bar_contact, user: @user)

    login_user @user
  end

  test "should get index" do
    get :index, format: :json
    assert_equal 200, response.status
    assert_equal [@contact].to_json, response.body
  end

  test "should create contact" do
    @new_contact = FactoryGirl.build(:invoice_bar_contact, user: @user)

    assert_difference('Contact.count') do
      post :create, format: :json, contact: {
        name:         @new_contact.name,
        tax_id:       @new_contact.tax_id,
        tax_id2:      @new_contact.tax_id2,
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
      tax_id:       999_112_58,
      tax_id2:      @contact.tax_id2,
      email:        @contact.email,
      phone:        @contact.phone,
      web:          @contact.web,
      bank_account: @contact.bank_account,
      user_id:      @contact.user_id }

    assert_equal 200, response.status

    @contact = Contact.find(@contact.id)
    assert_equal 'Updated contact', @contact.name
    assert_equal 999_112_58, @contact.tax_id
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, format: :json, id: @contact
    end

    assert_equal 200, response.status
  end
end
