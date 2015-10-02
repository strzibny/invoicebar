# Configure Rails Environment
ENV["RAILS_ENV"] = 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Show queries
ActiveRecord::Base.logger = Logger.new(STDOUT)

require 'shoulda'
require 'faker'
require 'factory_girl'
FactoryGirl.find_definitions

# Don't enforce locales for now
I18n.enforce_available_locales = false

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here
  include FactoryGirl::Syntax::Methods
  include Sorcery::TestHelpers::Rails

  # For login_user method
  include Sorcery::TestHelpers::Rails::Controller
end
