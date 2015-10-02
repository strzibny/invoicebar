module InvoiceBar
  class Address < ActiveRecord::Base
    attr_accessible :city, :city_part, :extra_address_line, :postcode, :street, :street_number

    validates :city,          presence: true#, length: { maximum: 50 }
    validates :postcode,      presence: true#, length: { in: 3..10 }
    validates :street,        presence: true#, length: { maximum: 50 }
    validates :street_number, presence: true#, length: { maximum: 15 }

    # Assosiations
    attr_accessible :addressable_id, :addressable_type

    belongs_to :addressable, polymorphic: true

    # Search
    include InvoiceBar::Searchable

    def self.searchable_fields
      ['city', 'city_part', 'extra_address_line', 'postcode', 'street', 'street_number']
    end

    def empty?
      attributes = ['city', 'city_part', 'street', 'street_number', 'postcode', 'extra_address_line']

      attributes.each do |attribute|
        unless eval "self.#{attribute}.blank?"
          return false
        end
      end

      return true
    end

    # Copies the address and returns a new instance.
    def copy
      Address.new(
        street: street,
        street_number: street_number,
        city: city,
        city_part: city_part,
        postcode: postcode,
        extra_address_line: extra_address_line
      )
    end
  end
end
