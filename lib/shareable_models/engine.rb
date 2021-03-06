#
# Engine to add to main rails app
#
module ShareableModels
  # Set the base engine to connect with rails
  class Engine < ::Rails::Engine
    engine_name 'shareable_models'

    config.generators do |g|
      g.test_framework :rspec, fixture: true
    end
  end
end
