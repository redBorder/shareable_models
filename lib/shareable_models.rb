# Require all files
require 'shareable_models/models/shareable'
require 'shareable_models/models/sharer'
require 'shareable_models/share'
require 'active_record'

# Extend active record with share options
ActiveRecord::Base.send :extend, ShareableModels::Share

# Only require if rails is available
require 'shareable_models/engine'

# Base module
module ShareableModels
end
