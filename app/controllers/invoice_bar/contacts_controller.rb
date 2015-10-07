module InvoiceBar
  class ContactsController < InvoiceBar::ApplicationController
    before_action :require_login
    before_action :set_contact, only: [:show, :edit, :update, :destroy]

    # GET /contacts
    # GET /contacts.json
    def index
      @contacts = current_user.contacts.page(params[:page])
    end

    # GET /contacts/1
    # GET /contacts/1.json
    def show
    end

    # GET /contacts/new
    def new
      @contact = InvoiceBar::Contact.new
      @contact.build_address
    end

    # GET /contacts/1/edit
    def edit
    end

    # POST /contacts
    # POST /contacts.json
    def create
      @contact = InvoiceBar::Contact.new(contact_params)
      current_user.contacts << @contact
      @contact.build_address unless @contact.address

      respond_to do |format|
        if @contact.save
          format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
          format.json { render :show, status: :created, location: @contact }
        else
          format.html { render :new }
          format.json { render json: @contact.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /contacts/1
    # PATCH/PUT /contacts/1.json
    def update
      respond_to do |format|
        if @contact.update(contact_params)
          format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
          format.json { render :show, status: :ok, location: @contact }
        else
          format.html { render :edit }
          format.json { render json: @contact.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /contacts/1
    # DELETE /contacts/1.json
    def destroy
      @contact.destroy
      respond_to do |format|
        format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
        format.json { head :no_content }
      end
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
