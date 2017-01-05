class Receipt < ActiveRecord::Base
  self.table_name = 'invoice_bar_receipts'

  before_validation :update_amount

  validates :number, presence: true
  validate :number_is_unique
  validates :items, length: { minimum: 1, message: 'Needs an item' }

  include InvoiceBar::Billable::Base
  include InvoiceBar::Billable::StrictValidations
  include InvoiceBar::Billable::Receipting

  include InvoiceBar::Billable::Associations::Base

  has_one :invoice

  include InvoiceBar::Billable::Filters

  # This one is contact's address
  has_one :address,
    -> { where(addressable_type: "Receipt#contact_address") },
    class_name: Address,
    foreign_key: :addressable_id,
    foreign_type: :addressable_type,
    dependent: :destroy,
    required: true
  has_many :items, as: :itemable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: false

  has_one :user_address,
    -> { where(addressable_type: "Receipt#user_address") },
    class_name: Address,
    foreign_key: :addressable_id,
    foreign_type: :addressable_type,
    dependent: :destroy,
    required: true
  accepts_nested_attributes_for :user_address, allow_destroy: true, reject_if: false

  # Search
  include InvoiceBar::Searchable

  def self.searchable_fields
    %w( number contact_name contact_tax_id )
  end

  def self.for_invoice(invoice)
    receipt = Receipt.new
    receipt.contact_name = invoice.contact_name
    receipt.contact_tax_id = invoice.contact_tax_id
    receipt.contact_tax_id2 = invoice.contact_tax_id2
    receipt.account_id = invoice.account_id
    receipt.issue_date = Date.today

    receipt.user_address = invoice.user_address.copy(
      addressable_type: "Receipt#user_address"
    )
    receipt.address = invoice.address.copy(
      addressable_type: "Receipt#contact_address"
    )

    invoice.items.each do |item|
      receipt.items << item.copy
    end

    receipt.note = invoice.note

    receipt
  end

  def mark_as_paid
    self.paid = true
  end

  def mark_as_sent
    self.sent = true
  end

  private

    # Validates uniqueness of a number for current user.
    def number_is_unique
      invoices = Receipt.where(number: number, user_id: user_id)

      if invoices.any? && !invoices.include?(self)
        errors.add(:number, :uniqueness)
      end
    end
end
