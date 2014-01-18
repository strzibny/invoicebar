# encoding: utf-8

module InvoiceBar
  class Currency < ActiveRecord::Base
    attr_accessible :name, :symbol, :priority

    validates :name,      :presence => true, :uniqueness => true
    validates :symbol,    :presence => true, :uniqueness => true, :length => { :maximum => 3 }
    validates :priority,  :presence => true

    has_many :accounts
  end
end
