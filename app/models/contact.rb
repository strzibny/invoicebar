class Contact < ActiveRecord::Base
  self.table_name = 'invoice_bar_contacts'

  attr_accessible :bank_account, :tax_id2, :email, :tax_id, :name, :phone, :web

  validates :name, presence: true

  validates :tax_id,  length: { in: 2..8 },   allow_blank: true
  validates :tax_id2, length: { in: 4..14 },  allow_blank: true

  # Associations
  attr_accessible :user_id, :address_attributes

  delegate :city, :city_part, :extra_address_line, :postcode, :street, :street_number,
           to: :address#, prefix: true

  has_one :address, as: :addressable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates :user_id, presence: true

  # Search
  include InvoiceBar::Searchable

  def self.searchable_fields
    %w( name tax_id email phone )
  end
end
