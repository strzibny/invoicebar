class CreateInvoiceBarContacts < ActiveRecord::Migration
  def change
    create_table :invoice_bar_contacts do |t|
      t.string :name, null: false, unique: true
      t.string :email, default: nil
      t.string :phone, default: nil
      t.string :web, default: nil
      t.string :bank_account, default: nil
      t.integer :tax_id, default: nil
      t.string :tax_id2, default: nil
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :invoice_bar_contacts, :name
    add_index :invoice_bar_contacts, :tax_id
  end
end
