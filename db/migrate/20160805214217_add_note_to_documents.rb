class AddNoteToDocuments < ActiveRecord::Migration
  def change
    add_column :invoice_bar_invoices, :note, :text
    add_column :invoice_bar_receipts, :note, :text
    add_column :invoice_bar_invoice_templates, :note, :text
    add_column :invoice_bar_receipt_templates, :note, :text
  end
end
