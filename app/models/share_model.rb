#
# Class to connect shared resources with another models. Resources are every
# class include shareable module. Shared_to can be any model with share_receiver
# module included.
#
class ShareModel < ActiveRecord::Base
  # Resource it's shared
  belongs_to :resource, polymorphic: true
  # Model with resource is shared
  belongs_to :shared_to, polymorphic: true
  # User who share resources
  belongs_to :shared_from, polymorphic: true

  validates :resource, :shared_to, :shared_from, presence: true
  # Every resource only can be shared with one person from same sharer one time.
  validates :resource_id, uniqueness: { scope: [:resource_type, :shared_to_id,
                                                :shared_to_type] }
end
