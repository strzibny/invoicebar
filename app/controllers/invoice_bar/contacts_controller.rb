# encoding: utf-8

module InvoiceBar
  class ContactsController < InvoiceBar::ApplicationController    
    inherit_resources
    respond_to :html, :json
    
    before_filter :require_login

    def new
      @contact = Contact.new
      @contact.build_address

      new!
    end

    def create
      @contact = Contact.new(params[:contact])    
      current_user.contacts << @contact
      
      @contact.build_address unless @contact.address

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
  
      def collection
        @contacts ||= end_of_association_chain.page(params[:page])
      end
  end
end