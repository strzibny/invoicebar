class AddRefFieldsDirectlyToReceipts < ActiveRecord::Migration
  def change
    change_table :invoice_bar_receipts do |t|
      t.string :user_name, default: nil
      t.integer :user_tax_id, default: nil
      t.string :user_tax_id2, default: nil
    end
  end
end
