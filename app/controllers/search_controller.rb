class SearchController < ApplicationController
  before_action :require_login

  def index
    @invoices = []
    @receipts = []
    @invoice_templates = []
    @receipt_templates = []
    @contacts = []

    if params[:search]
      query = params[:search]

      @invoices = current_user.invoices.search_for(query)
      @receipts = current_user.receipts.search_for(query)
      @invoice_templates = current_user.invoice_templates.search_for(query)
      @receipt_templates = current_user.receipt_templates.search_for(query)
      @contacts = current_user.contacts.search_for(query)
    end
  end
end
