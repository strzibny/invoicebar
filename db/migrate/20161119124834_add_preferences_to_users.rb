class AddPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :invoice_bar_users, :preferences, :text
  end
end
