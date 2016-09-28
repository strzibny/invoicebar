class InvoiceTemplate < ActiveRecord::Base
  self.table_name = 'invoice_bar_invoice_templates'

  before_validation :update_amount

  attr_accessible :name

  validates :name, presence: true
  validate :name_is_unique

  include InvoiceBar::Billable::Base
  include InvoiceBar::Billable::Invoicing

  include InvoiceBar::Billable::Associations::Base
  delegate :name, :tax_id, :address, to: :user, prefix: true

  # Search
  include InvoiceBar::Searchable

  def self.searchable_fields
    %w( name )
  end

  private

    # Validates uniqueness of a name for current user.
    def name_is_unique
      invoice_templates = InvoiceTemplate.where(name: name, user_id: user_id)

      if invoice_templates.any? && !invoice_templates.include?(self)
        errors.add(:name, :uniqueness)
      end
    end
end
