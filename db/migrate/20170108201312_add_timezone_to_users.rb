class AddTimezoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :invoice_bar_users, :time_zone, :string, limit: 255, default: 'UTC'
  end
end
