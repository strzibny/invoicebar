class AddRefFieldsDirectlyToReceipts < ActiveRecord::Migration
  def change
    change_table :invoice_bar_receipts do |t|
      t.string :user_name, default: nil
      t.integer :user_ic, default: nil
      t.string :user_dic, default: nil
    end
  end
end
