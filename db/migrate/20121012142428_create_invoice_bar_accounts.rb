class CreateInvoiceBarAccounts < ActiveRecord::Migration
  def change
    create_table :invoice_bar_accounts do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.string :bank_account_number, default: nil
      t.string :iban, default: nil
      t.string :swift, default: nil
      t.integer :amount, null: false, default: 0
      t.integer :currency_id, null: false, default: 1

      t.timestamps
    end

    add_index :invoice_bar_accounts, :name
  end
end
