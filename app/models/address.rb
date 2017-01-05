class Address < ActiveRecord::Base
  self.table_name = 'invoice_bar_addresses'

  validates :city,          presence: true, length: { maximum: 50 }
  validates :postcode,      presence: true, length: { in: 3..10 }
  validates :street,        presence: true, length: { maximum: 50 }
  validates :street_number, presence: true, length: { maximum: 15 }

  ADDRESS_COMPONENTS = %w( street street_number city city_part postcode
                           extra_address_line )

  # Associations
  belongs_to :addressable, polymorphic: true

  # Search
  include InvoiceBar::Searchable

  def self.searchable_fields
    ADDRESS_COMPONENTS
  end

  def empty?
    ADDRESS_COMPONENTS.each do |attribute|
      return false unless eval "self.#{attribute}.blank?"
    end || true
  end

  # Copies the address and returns a new instance.
  def copy(addressable_type: nil)
    Address.new(
      street: street,
      street_number: street_number,
      city: city,
      city_part: city_part,
      postcode: postcode,
      extra_address_line: extra_address_line,
      addressable_type: addressable_type
    )
  end
end
