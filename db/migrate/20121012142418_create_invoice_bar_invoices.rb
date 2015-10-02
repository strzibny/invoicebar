class CreateInvoiceBarInvoices < ActiveRecord::Migration
  def change
    create_table :invoice_bar_invoices do |t|
      t.string :number, null: false
      t.date :issue_date, null: false
      t.date :due_date, null: false
      t.string :contact_name, null: false
      t.integer :contact_ic, default: nil
      t.string :contact_dic, default: nil
      t.integer :user_id, null: false
      t.integer :payment_identification_number, default: nil
      t.integer :account_id, null: false
      t.integer :amount, null: false
      t.boolean :sent, null: false, default: false
      t.boolean :paid, null: false, default: false
      t.boolean :issuer, null: false, default: true
      t.integer :receipt_id, default: nil

      t.timestamps
    end

    add_index :invoice_bar_invoices, :number
    add_index :invoice_bar_invoices, :contact_name
    add_index :invoice_bar_invoices, :contact_ic
    add_index :invoice_bar_invoices, :payment_identification_number
  end
end
