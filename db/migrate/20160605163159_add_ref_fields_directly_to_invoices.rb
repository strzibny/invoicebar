class AddRefFieldsDirectlyToInvoices < ActiveRecord::Migration
  def change
    change_table :invoice_bar_invoices do |t|
      t.string :user_name, default: nil
      t.integer :user_ic, default: nil
      t.string :user_dic, default: nil
    end
  end
end
