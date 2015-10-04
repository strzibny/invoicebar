module InvoiceBar
  class User < ActiveRecord::Base
    attr_accessible :name, :email, :ic, :phone, :web, :administrator

    validates :name,  presence: true
    validates :email, presence: true, uniqueness: true
    validates :ic,    presence: true, numericality: true, length: { in: 2..8 }

    # Sorcery auth
    authenticates_with_sorcery!

    attr_accessible :password, :crypted_password, :salt,
                    :remember_me_token, :remember_me_token_expires_at,
                    :reset_password_email_sent_at, :reset_password_token,
                    :reset_password_token_expires_at

    # Associations
    attr_accessible :address_attributes

    delegate :street, :street_number, :city, :city_part, :postcode, :extra_address_line,
             to: :address

    has_many :accounts,           dependent: :destroy
    has_many :contacts,           dependent: :destroy
    has_many :invoices,           dependent: :destroy
    has_many :invoice_templates,  dependent: :destroy
    has_many :receipts,           dependent: :destroy
    has_many :receipt_templates,  dependent: :destroy

    has_one :address, as: :addressable, dependent: :destroy

    accepts_nested_attributes_for :address, allow_destroy: true

    # Search
    include InvoiceBar::Searchable

    def self.searchable_fields
      %w( name ic email phone )
    end
  end
end
