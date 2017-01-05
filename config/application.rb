require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InvoiceBar
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.paths << Rails.root.join('vendor', 'assets')

    config.i18n.default_locale = :cs
  end
end

# Concerns
require File.expand_path("../../app/concerns/invoice_bar/searchable.rb",  __FILE__)
require File.expand_path("../../app/concerns/invoice_bar/billable.rb",  __FILE__)
