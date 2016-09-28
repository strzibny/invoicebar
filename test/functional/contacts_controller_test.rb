require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Application.routes
    @user = FactoryGirl.create(:invoice_bar_user)
    @contact = FactoryGirl.create(:invoice_bar_contact, user: @user)

    login_user @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    @new_contact = FactoryGirl.build(:invoice_bar_contact, user: @user)

    assert_difference('Contact.count') do
      post :create, contact: {
        name:         @new_contact.name,
        tax_id:       @new_contact.tax_id,
        tax_id2:      @new_contact.tax_id2,
        email:        @new_contact.email,
        phone:        @new_contact.phone,
        web:          @new_contact.web,
        bank_account: @new_contact.bank_account,
        user_id:      @new_contact.user_id }
    end
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: {
      name:         @contact.name,
      tax_id:           @contact.tax_id,
      tax_id2:          @contact.tax_id2,
      email:        @contact.email,
      phone:        @contact.phone,
      web:          @contact.web,
      bank_account: @contact.bank_account,
      user_id:      @contact.user_id }
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end
  end
end
