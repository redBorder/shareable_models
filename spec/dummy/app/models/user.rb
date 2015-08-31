#
# Basic user model
#
class User < ActiveRecord::Base
  sharer
  # Resources user create
  has_many :resources
end
