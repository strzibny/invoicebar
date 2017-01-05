class Invoice < ActiveRecord::Base
  self.table_name = 'invoice_bar_invoices'

  before_validation :update_amount

  enum invoice_type: [ :basic, :deposit ]

  validates :number, presence: true
  validate :number_is_unique
  validates :items, length: { minimum: 1, message: 'Needs an item' }

  validates :due_date, presence: true

  include InvoiceBar::Billable::Base
  include InvoiceBar::Billable::StrictValidations
  include InvoiceBar::Billable::Invoicing

  include InvoiceBar::Billable::Associations::Base

  belongs_to :receipt

  include InvoiceBar::Billable::Filters

  # This one is contact's address
  has_one :address,
    -> { where(addressable_type: "Invoice#contact_address") },
    class_name: Address,
    foreign_key: :addressable_id,
    foreign_type: :addressable_type,
    dependent: :destroy,
    required: true
  has_many :items, as: :itemable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: false

  has_one :user_address,
    -> { where(addressable_type: "Invoice#user_address") },
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

  def mark_as_paid
    self.paid = true
  end

  def mark_as_sent
    self.sent = true
  end

  private

    # Validates uniqueness of a number for current user.
    def number_is_unique
      invoices = Invoice.where(number: number, user_id: user_id)

      if invoices.any? && !invoices.include?(self)
        errors.add(:number, :uniqueness)
      end
    end
end
