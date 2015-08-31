#
# Resource that users can share
#
class Resource < ActiveRecord::Base
  shareable owner: :user
  # Owner
  belongs_to :user
end
