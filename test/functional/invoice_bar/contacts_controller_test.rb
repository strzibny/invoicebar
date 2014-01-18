# encoding: utf-8

require 'test_helper'

class InvoiceBar::ContactsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:invoice_bar_user)
    @contact = FactoryGirl.create(:invoice_bar_contact, :user => @user)

    login_user
  end

  test "should get index" do
    get :index, use_route: :invoice_bar
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new, use_route: :invoice_bar
    assert_response :success
  end

  test "should create contact" do
    @new_contact = FactoryGirl.build(:invoice_bar_contact, :user => @user)

    assert_difference('InvoiceBar::Contact.count') do
      post :create, contact: {
        name:         @new_contact.name,
        ic:           @new_contact.ic,
        dic:          @new_contact.dic,
        email:        @new_contact.email,
        phone:        @new_contact.phone,
        web:          @new_contact.web,
        bank_account: @new_contact.bank_account,
        user_id:      @new_contact.user_id }, use_route: :invoice_bar
    end
  end

  test "should show contact" do
    get :show, id: @contact, use_route: :invoice_bar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact, use_route: :invoice_bar
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: {
      name:         @contact.name,
      ic:           @contact.ic,
      dic:          @contact.dic,
      email:        @contact.email,
      phone:        @contact.phone,
      web:          @contact.web,
      bank_account: @contact.bank_account,
      user_id:      @contact.user_id }, use_route: :invoice_bar
  end

  test "should destroy contact" do
    assert_difference('InvoiceBar::Contact.count', -1) do
      delete :destroy, id: @contact, use_route: :invoice_bar
    end
  end
end
