class ContactsController < ApplicationController
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
    @contact = Contact.new
    @contact.build_address
  end

  # GET /contacts/1/edit
  def edit
    @contact.build_address unless @contact.address
    respond_on_edit @contact
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    current_user.contacts << @contact
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
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:bank_account, :tax_id2, :email, :tax_id, :name,
                                      :phone, :web, :user_id, :address_attributes => [
                                        :street,
                                        :street_number,
                                        :postcode,
                                        :city,
                                        :city_part,
                                        :extra_address_line
                                        ])
    end
end
