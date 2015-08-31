require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
#require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    # Do not swallow errors in after_commit/after_rollback callbacks.
    if Rails.version > '3.2.0'
      config.active_record.raise_in_transactional_callbacks = true
    end
    config.encoding = 'utf-8'
    config.eager_load = false
  end
end
