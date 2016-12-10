require 'formatted-money'

class Item < ActiveRecord::Base
  self.table_name = 'invoice_bar_items'

  before_validation :update_amount

  attr_accessible :name, :number, :price, :unit, :human_price, :human_amount, :deposit_invoice

  validates :name, presence: true
  validates :number, numericality: true, length: { maximum: 10 }, allow_blank: true
  validates :price, presence: true, numericality: true
  validates :unit, length: { maximum: 10 }, allow_blank: true

  # Associations
  attr_accessible :itemable_id, :itemable_type

  belongs_to :itemable, polymorphic: true

  # Each item can be paired with deposit invoice, in that case item's amount
  # needs to match with the deposit invoice amount (only it's negative).
  has_one :deposit_invoice, class_name: Invoice

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
    self.amount = total
  end

  # Calculates the total by multiplying price by number (of units).
  def total()
    if price.blank? and number.blank?
      return 0
    end

    total = Integer(price)
    total = Integer(price) * Integer(number) unless number.nil?

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
