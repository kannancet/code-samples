require "bundler/setup"
require 'vcr'
require 'factory_bot'
require 'stockman'

RSpec.configure do |config|

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  #Configure factory bot
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

end

#Configure VCR
VCR.configure do |config|
  config.cassette_library_dir = "spec/factories/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

#Pony mail set to test
Pony.override_options = {via: :test}

#Rspec matcher for aatr_accessors on models
RSpec::Matchers.define :have_attr_accessor do |field|
  match do |object_instance|
    object_instance.respond_to?(field) &&
      object_instance.respond_to?("#{field}=")
  end

  failure_message_for_should do |object_instance|
    "expected attr_accessor for #{field} on #{object_instance}"
  end

  failure_message_for_should_not do |object_instance|
    "expected attr_accessor for #{field} not to be defined on #{object_instance}"
  end

  description do
    "checks to see if there is an attr accessor on the supplied object"
  end
end
