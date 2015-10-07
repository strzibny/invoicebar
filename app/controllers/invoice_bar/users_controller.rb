module InvoiceBar
  class UsersController < InvoiceBar::ApplicationController
    before_action :require_login, only: [:update]
    before_action :require_admin_rights, only: [:index, :edit, :destroy]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    layout :set_layout

    # GET /users
    # GET /users.json
    def index
      @users = InvoiceBar::User.all.page(params[:page])
    end

    # GET /users/1
    # GET /users/1.json
    def show
    end

    # This is sign up process.
    # GET /users/new
    def new
      @user = InvoiceBar::User.new
      @user.build_address
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users
    # POST /users.json
    def create
      @user = InvoiceBar::User.new(user_params)

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

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
      params[:controller] = 'settings'

      @user = User.find(current_user.id)
      @user.update_attributes(user_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to profile_path, notice: t('flash.actions.update.notice') }
          format.json { render json: @user, status: :updated, location: @user }
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
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

      def set_user
        @user = InvoiceBar::User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :ic, :phone, :web,
                                     :administrator, :password, :crypted_password,
                                     :salt, :remember_me_token, :remember_me_token_expires_at,
                                     :reset_password_email_sent_at, :reset_password_token,
                                     :reset_password_token_expires_at, :address_attributes)
      end

      def set_layout
        case action_name
        when 'new', 'create'
          'invoice_bar/layouts/signed_out'
        when 'index', 'update'
          'invoice_bar/layouts/signed_in'
        else
          'invoice_bar/layouts/signed_out'
        end
      end
  end
end
