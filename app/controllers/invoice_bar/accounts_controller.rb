# encoding: utf-8

module InvoiceBar
  class AccountsController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json 
    
    before_filter :require_login
    before_filter :fetch_currencies, :only => [:new, :create, :edit, :update]
    
    def create
      @account = Account.new(params[:account])    
      current_user.accounts << @account
      
      create! {}
    end
    
    def update
      update! {}
    end
    
    def destroy
      destroy! {}
    end
    
    protected
    
      def begin_of_association_chain
        current_user
      end
  end
end