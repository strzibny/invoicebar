class AddDepositInvoiceIdToInvoiceBarItems < ActiveRecord::Migration
  def change
    add_column :invoice_bar_items, :deposit_invoice_id, :integer, default: nil
  end
end
