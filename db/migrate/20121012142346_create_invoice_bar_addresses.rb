class CreateInvoiceBarAddresses < ActiveRecord::Migration
  def change
    create_table :invoice_bar_addresses do |t|
      t.string :street, :null => false
      t.string :street_number, :null => false
      t.string :city, :null => false
      t.string :city_part, :default => nil
      t.string :postcode, :null => false
      t.string :extra_address_line, :default => nil
      t.integer :addressable_id, :null => false
      t.string :addressable_type, :null => false

      t.timestamps
    end
  end
end
