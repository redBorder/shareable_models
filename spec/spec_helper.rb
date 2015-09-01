# Base configuration for RSPEC
ENV['RAILS_ENV'] ||= 'test'

# Code Climate reporter
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  # For fixtures
  config.use_transactional_fixtures = true
  config.global_fixtures = :all
  config.fixture_path = './spec/fixtures'

  # rspec-mocks config goes here
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
