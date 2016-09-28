class Account < ActiveRecord::Base
  self.table_name = 'invoice_bar_accounts'

  attr_accessible :amount, :bank_account_number, :iban, :name, :swift

  validates :name,    presence: true
  validates :amount,  presence: true, numericality: true

  validates :iban,  length: { in: 15..34 }, allow_blank: true
  validates :swift, length: { in: 8..11 }, allow_blank: true

  validate :name_is_unique

  # Assosiations
  attr_accessible :user_id, :currency_id

  belongs_to :currency
  belongs_to :user
  has_many :invoices
  has_many :receipts

  validates :currency_id, presence: true
  validates :user_id, presence: true

  # Search
  include InvoiceBar::Searchable

  def self.searchable_fields
    %w( name iban swift bank_account_number )
  end

  def currency_name
    currency.name if currency
  end

  def currency_symbol
    currency.symbol if currency
  end

  def balance
    balance = amount

    receipts.expense.each do |receipt|
      balance -= receipt.amount
    end

    receipts.income.each do |receipt|
      balance += receipt.amount
    end

    balance
  end

  private

    # Validates uniqueness of a name for current user.
    def name_is_unique
      accounts = Account.where(name: name, user_id: user_id)

      if accounts.any? && !accounts.include?(self)
        errors.add(:name, :uniqueness)
      end
    end
end
