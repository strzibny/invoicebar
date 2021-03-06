class User < ActiveRecord::Base
  self.table_name = 'invoice_bar_users'

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  #validates :tax_id,    presence: true, numericality: true#, length: { in: 2..8 }

  # Sorcery auth
  authenticates_with_sorcery!

  # Associations
  delegate :street, :street_number, :city, :city_part, :postcode, :extra_address_line,
           to: :address

  has_many :accounts,           dependent: :destroy
  has_many :contacts,           dependent: :destroy
  has_many :invoices,           dependent: :destroy
  has_many :invoice_templates,  dependent: :destroy
  has_many :receipts,           dependent: :destroy
  has_many :receipt_templates,  dependent: :destroy

  has_one :address, as: :addressable, dependent: :destroy, required: true

  accepts_nested_attributes_for :address, allow_destroy: true

  # Search
  include InvoiceBar::Searchable

  def self.searchable_fields
    %w( name tax_id email phone )
  end

  # Preferences
  serialize :preferences, Hash

  def tax_id2
    tax_id
  end
end
