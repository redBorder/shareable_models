#
# Namespace of Shareable.
#
module ShareableModels
  #
  #  It's define the options to set a model as sharer or shareable
  #
  module Share
    #
    # Define a model as shareable. A shareable model can be shared between
    # other models called sharers. Imagine a platform with privates articles,
    # you could want to share your awesome article with other person, so
    # make it shareable.
    #
    # == Parameters:
    # options:
    #   A hash with options to personalize the way to share the model.
    #     - owner: name of relation that point to the create of resource.
    #              For example, the author of an Article. Owners always can
    #              read and edit the resources.
    #
    def shareable(options = {})
      include ShareableModels::Models::Shareable

      # Add some relations
      has_many :shared_with, as: :resource, class_name: 'ShareModel'

      class_attribute :shareable_options
      self.shareable_options = options
    end

    #
    # Define a model as sharer. A sharer model can share another models that
    # it has edit permissions or it is owner. Following the example of Articles,
    # Sharer model will be Author model.
    #
    # A sharer can only receive shareable elements too. For example, you could
    # define a Group model that englobe multiple authors. Group can be a sharer
    # that only receive shares from Authors (another shares) to share Article
    # with multiple authors.
    #
    def sharer
      include ShareableModels::Models::Sharer

      # Add some relations
      has_many :shared_resources, as: :sharer, class_name: 'ShareModel'
      has_many :shared_with_me, as: :shared_to, class_name: 'ShareModel'
    end
  end
end
