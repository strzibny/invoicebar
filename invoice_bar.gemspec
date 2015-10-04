$:.push File.expand_path("../lib", __FILE__)

# Gem's version:
require "invoice_bar/version"

Gem::Specification.new do |s|
  s.name        = "invoice_bar"
  s.version     = InvoiceBar::VERSION
  s.authors     = ["Josef Strzibny"]
  s.email       = ["strzibny@strzibny.name"]
  s.homepage    = "http://github.com/strzibny/invoicebar"
  s.summary     = "Rails Engine for single-entry invoicing"
  s.description = "Rails Engine for single-entry invoicing."
  s.license     = "GPLv2"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "protected_attributes"
  s.add_dependency "rails-i18n"
  s.add_dependency "nested_form"
  s.add_dependency "inherited_resources", "1.3.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "prawn"
  s.add_dependency "prawn-layout"
  s.add_dependency "prawnto"
  s.add_dependency "sorcery"
  s.add_dependency "formatted-money"
  s.add_dependency "json"
  s.add_dependency "ruby-ares"
  s.add_dependency "kaminari"
  s.add_dependency "therubyracer"
  s.add_dependency "libv8", "~> 3.11.8"
end
