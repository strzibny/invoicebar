module InvoiceBar
  module Billable
    module Associations
      module Base
        extend ActiveSupport::Concern

        included do
          delegate :city, :city_part, :extra_address_line, :postcode, :street, :street_number,
                   to: :user, prefix: true

          delegate :city, :city_part, :extra_address_line, :postcode, :street, :street_number,
                   to: :user_address, prefix: true

          delegate :city, :city_part, :extra_address_line, :postcode, :street, :street_number,
                   to: :address, prefix: true

          delegate :name, :bank_account_number, :swift, :iban,
                   to: :account, prefix: true

          belongs_to :account
          belongs_to :user

          has_one :address, as: :addressable, dependent: :destroy
          has_many :items, as: :itemable, dependent: :destroy

          accepts_nested_attributes_for :items, allow_destroy: true, reject_if: :all_blank
          accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

          validates :user_id, presence: true, numericality: true
        end
      end
    end
  end
end
