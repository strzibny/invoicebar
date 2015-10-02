# encoding: utf-8

module InvoiceBar
  class Account < ActiveRecord::Base
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
      ['name', 'iban', 'swift', 'bank_account_number']
    end

    def currency_name
      currency.name if currency
    end

    def currency_symbol
      currency.symbol if currency
    end

    def balance
      balance = amount

      self.receipts.expense.each do |receipt|
        balance = balance - receipt.amount
      end

      self.receipts.income.each do |receipt|
        balance = balance + receipt.amount
      end

      balance
    end

    private

      # Validates uniqueness of a name for current user.
      def name_is_unique
        accounts = Account.where(name: self.name, user_id: self.user_id)

        if accounts.any?
          errors.add(:name, :uniqueness) unless accounts.include? self
        end
      end
  end
end
