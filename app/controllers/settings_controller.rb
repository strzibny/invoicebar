class SettingsController < ApplicationController
  before_action :require_login

  def index
    @user = current_user
  end

  def sequences
    @user = current_user
  end

  def update_sequences
    current_user.preferences = {
      received_invoice_sequence: params[:received_invoice_sequence],
      issued_invoice_sequence:   params[:issued_invoice_sequence],
      received_deposit_invoice_sequence: params[:received_deposit_invoice_sequence],
      issued_deposit_invoice_sequence:   params[:issued_deposit_invoice_sequence],
      income_bill_sequence:      params[:income_bill_sequence],
      expense_bill_sequence:     params[:expense_bill_sequence],

      last_received_invoice:     params[:last_received_invoice],
      last_issued_invoice:       params[:last_issued_invoice],
      last_received_deposit_invoice:     params[:last_received_deposit_invoice],
      last_issued_deposit_invoice:       params[:last_issued_deposit_invoice],
      last_income_bill_number:   params[:last_income_bill_number],
      last_expense_bill_number:  params[:last_expense_bill_number]
    }
    current_user.save!

    redirect_to :back
  end
end
