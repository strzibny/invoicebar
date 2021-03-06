class UsersController < ApplicationController
  before_action :require_login, only: [:update]
  before_action :require_admin_rights, only: [:index, :edit, :destroy]
  before_action :set_user, only: [:show, :edit, :destroy]
  layout :set_layout

  # GET /users
  # GET /users.json
  def index
    @users = User.all.page(params[:page])
    respond_on_index @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_on_show @user
  end

  # This is sign up process.
  # GET /users/new
  def new
    @user = User.new
    @user.build_address
    respond_on_new @user
  end

  # GET /users/1/edit
  def edit
    respond_on_edit @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.build_address unless @user.address

    # First user is an administrator
    @user.administrator = true unless User.all.size > 0

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: t('messages.signed_up') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Update current user
  # TODO: Allow editing and updating user for administrators
  def update
    params[:controller] = 'settings'

    @user = current_user
    @user.update_attributes(user_params)
    @user.address.update_attributes(user_params[:address_attributes])

    respond_to do |format|
      if @user.save
        format.html { redirect_to account_settings_path, notice: t('flash.actions.update.notice') }
        format.json { render json: @user, status: 200, location: @user }
      else
        format.html { render template: 'invoice_bar/settings/index' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_on_destroy @user, user_url
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :tax_id, :phone, :web,
                                   :administrator, :password, :crypted_password,
                                   :salt, :remember_me_token, :remember_me_token_expires_at,
                                   :reset_password_email_sent_at, :reset_password_token,
                                   :reset_password_token_expires_at, :time_zone,
                                   :address_attributes => [
                                     :street,
                                     :street_number,
                                     :postcode,
                                     :city,
                                     :city_part,
                                     :extra_address_line
                                   ])
    end

    def set_layout
      case action_name
      when 'new', 'create'
        'layouts/signed_out'
      when 'index', 'update'
        'layouts/signed_in'
      else
        'layouts/signed_out'
      end
    end
end
