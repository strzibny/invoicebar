class CreateInvoiceBarUsers < ActiveRecord::Migration
  def change
    create_table :invoice_bar_users do |t|
      t.string :email, null: false, unique: true
      t.string :crypted_password, default: nil
      t.string :salt, default: nil
      t.string :remember_me_token, default: nil
      t.datetime :remember_me_token_expires_at, default: nil
      t.string :reset_password_token, default: nil
      t.datetime :reset_password_token_expires_at, default: nil
      t.datetime :reset_password_email_sent_at, default: nil
      t.string :name, null: false
      t.string :phone, default: nil
      t.string :web, default: nil
      t.integer :tax_id, null: false, unique: true
      t.boolean :administrator

      t.timestamps
    end

    add_index :invoice_bar_users, :reset_password_token
    add_index :invoice_bar_users, :remember_me_token
  end
end
