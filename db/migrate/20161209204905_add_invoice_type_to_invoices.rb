class AddInvoiceTypeToInvoices < ActiveRecord::Migration
  def change
    add_column :invoice_bar_invoices, :invoice_type, :integer, default: 0
  end
end
