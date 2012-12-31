class CreateInvoiceBarReceipts < ActiveRecord::Migration
  def change
    create_table :invoice_bar_receipts do |t|
      t.string :number, :null => false
      t.date :issue_date, :null => false
      t.string :contact_name, :null => false
      t.integer :contact_ic, :default => nil
      t.string :contact_dic, :default => nil
      t.integer :user_id, :null => false
      t.integer :account_id, :null => false
      t.integer :amount, :null => false
      t.boolean :issuer, :null => false, :default => true

      t.timestamps
    end
    
    add_index :invoice_bar_receipts, :number
    add_index :invoice_bar_receipts, :contact_name
    add_index :invoice_bar_receipts, :contact_ic
  end
end
