# encoding: utf-8

require 'formatted-money'

module InvoiceBar
  class Item < ActiveRecord::Base
    before_validation :update_amount

    attr_accessible :name, :number, :price, :unit, :human_price, :human_amount

    validates :name, :presence => true
    validates :number, :numericality => true, :length => { :maximum => 10 }, :allow_blank => true
    validates :price, :presence => true, :numericality => true
    validates :unit, :length => { :maximum => 10 }, :allow_blank => true

    # Associations
    attr_accessible :itemable_id, :itemable_type

    belongs_to :itemable, :polymorphic => true

    # Copies the item and returns a new instance.
    def copy
      item = Item.new(
        name: name,
        number: number,
        price: price,
        unit: unit
      )

      item.update_amount

      item
    end

    def update_amount
      self.amount = self.total
    end

    # Calculates the total by multiplying price by number (of units).
    def total()
      if self.price.blank? and self.number.blank?
        return 0
      end

      total = Integer(self.price)
      total = Integer(self.price) * Integer(self.number) unless self.number.nil?

      total
    end

    # Writes price using FormattedMoney for converting the user input.
    def price=(price)
      begin
        cents = FormattedMoney.cents(price.gsub(' ', ''))
      rescue
        cents = price
      end

      write_attribute(:price, cents)
    end

    # Price in cents
    def price
      read_attribute(:price)
    end

    # Returns price in a human-readable way.
    def human_price
      FormattedMoney.amount(read_attribute(:price))
    end

    # Returns total amount in a human-readable way.
    def human_amount
      FormattedMoney.amount(read_attribute(:amount))
    end
  end
end
