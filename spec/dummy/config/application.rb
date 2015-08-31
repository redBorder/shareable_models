require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
#require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true
    config.encoding = 'utf-8'
    config.eager_load = false
  end
end
