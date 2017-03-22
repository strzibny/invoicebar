class MigrateTaxIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :invoice_bar_users, :tax_id, :string
    change_column :invoice_bar_contacts, :tax_id, :string

    change_column :invoice_bar_invoice_templates, :contact_tax_id, :string
    change_column :invoice_bar_invoices, :contact_tax_id, :string
    change_column :invoice_bar_invoices, :user_tax_id, :string

    change_column :invoice_bar_receipt_templates, :contact_tax_id, :string
    change_column :invoice_bar_receipts, :contact_tax_id, :string
    change_column :invoice_bar_receipts, :user_tax_id, :string
  end
end
