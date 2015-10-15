module InvoiceBar
  class ContactsController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :set_contact, only: [:show, :edit, :update, :destroy]

    # GET /contacts
    # GET /contacts.json
    def index
      @contacts = current_user.contacts.page(params[:page])
      respond_on_index @contacts
    end

    # GET /contacts/1
    # GET /contacts/1.json
    def show
      respond_on_show @contact
    end

    # GET /contacts/new
    def new
      @contact = InvoiceBar::Contact.new
      @contact.build_address
    end

    # GET /contacts/1/edit
    def edit
      respond_on_edit @contact
    end

    # POST /contacts
    # POST /contacts.json
    def create
      @contact = InvoiceBar::Contact.new(contact_params)
      current_user.contacts << @contact
      @contact.build_address unless @contact.address
      respond_on_create @contact
    end

    # PATCH/PUT /contacts/1
    # PATCH/PUT /contacts/1.json
    def update
      respond_on_update @contact, contact_params
    end

    # DELETE /contacts/1
    # DELETE /contacts/1.json
    def destroy
      @contact.destroy
      respond_on_destroy @contact, contact_url
    end

    private

      def set_contact
        @contact = InvoiceBar::Contact.find(params[:id])
      end

      def contact_params
        params.require(:contact).permit(:bank_account, :dic, :email, :ic, :name,
                                        :phone, :web, :user_id, :address_attributes)
      end
  end
end
