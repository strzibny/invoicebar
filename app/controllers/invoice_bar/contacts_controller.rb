module InvoiceBar
  class ContactsController < InvoiceBar::ApplicationController
    inherit_resources
    respond_to :html, :json

    before_filter :require_login

    def index
      @contacts = current_user.contacts.page(params[:page])

      index! {}
    end

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

      def collection
        @contacts ||= end_of_association_chain.page(params[:page])
      end
  end
end
