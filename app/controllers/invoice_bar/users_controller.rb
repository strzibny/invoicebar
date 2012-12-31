# encoding: utf-8

module InvoiceBar
  class UsersController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json
    
    before_filter :require_login, only: [:update]
    before_filter :require_admin_rights, only: [:index, :edit, :destroy]

    layout :set_layout
    
    # Sign up
    def new
      @user = User.new
      @user.build_address
    
      respond_to do |format|
        format.html
        format.json { render json: @user }
      end
    end

    def create
      @user = User.new(params[:user])
      
      # First user is an administrator
      unless User.all.size > 0
        @user.administrator = true
      end

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
    
    def update
      params[:controller] = 'settings'
      
      @user = User.find(current_user.id)
      @user.update_attributes(params[:user])
      
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
    
    def destroy
      destroy! {}
    end
    
    protected
  
      def collection
        @users ||= end_of_association_chain.page(params[:page])
      end
    
    private

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