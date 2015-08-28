# Base configuration for RSPEC
ENV['RAILS_ENV'] ||= 'test'
require 'rspec/rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
