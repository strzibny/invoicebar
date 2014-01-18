# encoding: utf-8

require 'bootstrap-sass'
require 'kaminari'
require 'prawn'
require 'prawnto'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'sorcery'
require 'inherited_resources'
require 'nested_form'

# ARES
require 'xml'
require 'ruby-ares'

require 'formatted-money'

require File.expand_path("../../billable.rb",  __FILE__)
require File.expand_path("../../searchable.rb",  __FILE__)

I18n.locale = :cs

module InvoiceBar
  class Engine < ::Rails::Engine
    isolate_namespace InvoiceBar
  end

  module Generators
    # Document numbers generators defaults
    @@issued_invoice_number = Proc.new do |n|
      "VF#{self.default_number(n)}"
    end unless defined? @@issued_invoice_number

    @@received_invoice_number = Proc.new do |n|
      "PF#{self.default_number(n)}"
    end unless defined? @@received_invoice_number

    @@expense_receipt_number = Proc.new do |n|
      "VD#{self.default_number(n)}"
    end unless defined? @@expense_receipt_number

    @@income_receipt_number = Proc.new do |n|
      "PD#{self.default_number(n)}"
    end unless defined? @@income_receipt_number

    def self.issued_invoice_number(n)
      @@issued_invoice_number.call(n)
    end

    def self.received_invoice_number(n)
      @@received_invoice_number.call(n)
    end

    def self.income_receipt_number(n)
      @@income_receipt_number.call(n)
    end

    def self.expense_receipt_number(n)
      @@expense_receipt_number.call(n)
    end

    def self.default_number(n)
      t = Time.now
      number = "#{t.year}#{t.month}#{self.with_zeros(n)}"
      number
    end

    def self.with_zeros(n)
      length = n.to_s.length
      number_of_zeros = Integer(4-length)
      zeros = ''

      number_of_zeros.times do
        zeros += '0'
      end

      "#{zeros}#{n}"
    end
  end
end
