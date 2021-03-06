# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170322194319) do

  create_table "invoice_bar_accounts", force: :cascade do |t|
    t.string   "name",                            null: false
    t.integer  "user_id",                         null: false
    t.string   "bank_account_number"
    t.string   "iban"
    t.string   "swift"
    t.integer  "amount",              default: 0, null: false
    t.integer  "currency_id",         default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_invoice_bar_accounts_on_name"
  end

  create_table "invoice_bar_addresses", force: :cascade do |t|
    t.string   "street",             null: false
    t.string   "street_number",      null: false
    t.string   "city",               null: false
    t.string   "city_part"
    t.string   "postcode",           null: false
    t.string   "extra_address_line"
    t.integer  "addressable_id",     null: false
    t.string   "addressable_type",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_bar_contacts", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "email"
    t.string   "phone"
    t.string   "web"
    t.string   "bank_account"
    t.string   "tax_id"
    t.string   "tax_id2"
    t.integer  "user_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_invoice_bar_contacts_on_name"
    t.index ["tax_id"], name: "index_invoice_bar_contacts_on_tax_id"
  end

  create_table "invoice_bar_currencies", force: :cascade do |t|
    t.string  "name",                 null: false
    t.string  "symbol",               null: false
    t.integer "priority", default: 1, null: false
  end

  create_table "invoice_bar_invoice_templates", force: :cascade do |t|
    t.string   "name",                          null: false
    t.date     "issue_date"
    t.date     "due_date"
    t.string   "contact_name"
    t.string   "contact_tax_id"
    t.string   "contact_tax_id2"
    t.integer  "user_id"
    t.integer  "payment_identification_number"
    t.integer  "account_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
    t.index ["name"], name: "index_invoice_bar_invoice_templates_on_name"
  end

  create_table "invoice_bar_invoices", force: :cascade do |t|
    t.string   "number",                                        null: false
    t.date     "issue_date",                                    null: false
    t.date     "due_date",                                      null: false
    t.string   "contact_name",                                  null: false
    t.string   "contact_tax_id"
    t.string   "contact_tax_id2"
    t.integer  "user_id",                                       null: false
    t.integer  "payment_identification_number"
    t.integer  "account_id",                                    null: false
    t.integer  "amount",                                        null: false
    t.boolean  "sent",                          default: false, null: false
    t.boolean  "paid",                          default: false, null: false
    t.boolean  "issuer",                        default: true,  null: false
    t.integer  "receipt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
    t.string   "user_tax_id"
    t.string   "user_tax_id2"
    t.text     "note"
    t.integer  "invoice_type",                  default: 0
    t.index ["contact_name"], name: "index_invoice_bar_invoices_on_contact_name"
    t.index ["contact_tax_id"], name: "index_invoice_bar_invoices_on_contact_tax_id"
    t.index ["number"], name: "index_invoice_bar_invoices_on_number"
    t.index ["payment_identification_number"], name: "index_invoice_bar_invoices_on_payment_identification_number"
  end

  create_table "invoice_bar_items", force: :cascade do |t|
    t.string   "name",               null: false
    t.integer  "price",              null: false
    t.string   "unit"
    t.integer  "number"
    t.integer  "amount",             null: false
    t.integer  "itemable_id",        null: false
    t.string   "itemable_type",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposit_invoice_id"
    t.index ["name"], name: "index_invoice_bar_items_on_name"
  end

  create_table "invoice_bar_receipt_templates", force: :cascade do |t|
    t.string   "name",            null: false
    t.date     "issue_date"
    t.string   "contact_name"
    t.string   "contact_tax_id"
    t.string   "contact_tax_id2"
    t.integer  "user_id"
    t.integer  "account_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
    t.index ["name"], name: "index_invoice_bar_receipt_templates_on_name"
  end

  create_table "invoice_bar_receipts", force: :cascade do |t|
    t.string   "number",                         null: false
    t.date     "issue_date",                     null: false
    t.string   "contact_name",                   null: false
    t.string   "contact_tax_id"
    t.string   "contact_tax_id2"
    t.integer  "user_id",                        null: false
    t.integer  "account_id",                     null: false
    t.integer  "amount",                         null: false
    t.boolean  "issuer",          default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
    t.string   "user_tax_id"
    t.string   "user_tax_id2"
    t.text     "note"
    t.index ["contact_name"], name: "index_invoice_bar_receipts_on_contact_name"
    t.index ["contact_tax_id"], name: "index_invoice_bar_receipts_on_contact_tax_id"
    t.index ["number"], name: "index_invoice_bar_receipts_on_number"
  end

  create_table "invoice_bar_users", force: :cascade do |t|
    t.string   "email",                                                       null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "name",                                                        null: false
    t.string   "phone"
    t.string   "web"
    t.string   "tax_id",                                                      null: false
    t.boolean  "administrator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "preferences"
    t.string   "time_zone",                       limit: 255, default: "UTC"
    t.index ["remember_me_token"], name: "index_invoice_bar_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_invoice_bar_users_on_reset_password_token"
  end

end
