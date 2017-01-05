class Currency < ActiveRecord::Base
  self.table_name = 'invoice_bar_currencies'

  validates :name, presence: true, uniqueness: true
  validates :symbol, presence: true, uniqueness: true, length: { maximum: 3 }
  validates :priority, presence: true

  has_many :accounts
end
