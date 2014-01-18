class CreateInvoiceBarItems < ActiveRecord::Migration
  def change
    create_table :invoice_bar_items do |t|
      t.string :name, :null => false
      t.integer :price, :null => false
      t.string :unit, :default => nil
      t.integer :number, :default => nil
      t.integer :amount, :null => false
      t.integer :itemable_id, :null => false
      t.string :itemable_type, :null => false

      t.timestamps
    end

    add_index :invoice_bar_items, :name
  end
end
