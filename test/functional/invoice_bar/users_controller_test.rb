require 'test_helper'

class InvoiceBar::UsersControllerTest < ActionController::TestCase
  setup do
    @routes = InvoiceBar::Engine.routes
    @user = FactoryGirl.create(:invoice_bar_user, administrator: true)

    login_user @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    @new_user = FactoryGirl.build(:invoice_bar_user)

    assert_difference('InvoiceBar::User.count') do
      post :create, user: {
        name: @new_user.name,
        email: @new_user.email,
        tax_id: @new_user.tax_id,
        crypted_password: @new_user.crypted_password,
        phone: @new_user.phone,
        remember_me_token: @new_user.remember_me_token,
        remember_me_token_expires_at: @new_user.remember_me_token_expires_at,
        reset_password_email_sent_at: @new_user.reset_password_email_sent_at,
        reset_password_token: @new_user.reset_password_token,
        reset_password_token_expires_at: @new_user.reset_password_token_expires_at,
        salt: @new_user.salt,
        web: @new_user.web,
        address_attributes: {
          street: @new_user.address.street,
          street_number: @new_user.address.street_number,
          postcode: @new_user.address.postcode,
          city: @new_user.address.city,
          city_part: @new_user.address.city_part,
          extra_address_line: @new_user.address.extra_address_line }}
    end
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: {
      name: @user.name,
      email: @user.email,
      tax_id: @user.tax_id,
      crypted_password: @user.crypted_password,
      phone: @user.phone,
      remember_me_token: @user.remember_me_token,
      remember_me_token_expires_at: @user.remember_me_token_expires_at,
      reset_password_email_sent_at: @user.reset_password_email_sent_at,
      reset_password_token: @user.reset_password_token,
      reset_password_token_expires_at: @user.reset_password_token_expires_at,
      salt: @user.salt,
      web: @user.web,
      address_attributes: {
        street: @user.street,
        street_number: @user.street_number,
        postcode: @user.postcode,
        city: @user.city,
        city_part: @user.city_part,
        extra_address_line: @user.extra_address_line }}
  end

  test "should destroy user" do
    assert_difference('InvoiceBar::User.count', -1) do
      delete :destroy, id: @user
    end
  end
end
