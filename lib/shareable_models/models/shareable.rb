#
# Namespace of Shareable.
#
module ShareableModels
  #
  # Modules to include in models that will use shareable options
  #
  module Models
    #
    # Define a model as shareable. A shareable model can be shared between
    # other models called sharers. Imagine a platform with privates articles,
    # you could want to share your awesome article with other person, so
    # make it shareable.
    #
    module Shareable
      #
      # Method to determine if a model can be shared. It always true because
      # the class includes this module.
      #
      # == Returns
      # true
      #
      def shareable?
        true
      end

      #
      # Return the shareable owner
      #
      def shareable_owner
        return nil if shareable_options.nil? || shareable_options[:owner].nil?
        send(shareable_options[:owner])
      end

      #
      # Share current element with a sharer model.
      #
      # == Parameters:
      # from::
      #   Instance of model with share this resource
      # to::
      #   Instance of model to share with
      # edit::
      #   True if the user has edit permission. False by default
      #
      # == Returns:
      # true if its saved.
      #
      def share_it(from, to, edit = false)
        from.share(self, to, edit)
      end

      #
      # Throw out an user from this resource
      #
      # == Parameters:
      # from::
      #   Sharer that want to leave resource.
      # to::
      #   Sharer that want to leave resource.
      #
      # == Returns:
      # True if it's ok
      #
      def throw_out(from, to)
        from.throw_out(self, to)
      end

      #
      # Allow given sharer to leave the resource
      #
      # == Parameters:
      # sharer::
      #   Sharer that want to leave resource.
      #
      # == Returns:
      # True if it's ok
      #
      def leave_by(sharer)
        sharer.leave(self)
      end

      #
      # Permissions
      # ----------------------------------------------------

      #
      # Check if a given sharer can edit this resource
      #
      # == Parameters:
      # from::
      #   Sharer that wants to edit the user.
      #
      # == Returns:
      # true if the sharer can edit it
      #
      def editable_by?(from)
        from.can_edit?(self)
      end

      #
      # Check if a given sharer can see this resource
      #
      # == Parameters:
      # from::
      #   Sharer that wants to see the user.
      #
      # == Returns:
      # true if the sharer can see it
      #
      def readable_by?(from)
        from.can_read?(self)
      end

      #
      # Allow a sharer to edit the resource
      #
      # == Parameters:
      # from::
      #   Sharer that want to allow another to edit resource
      # to::
      #   Sharer that will be able to edit the resource
      #
      # == Returns:
      # True if it's ok
      #
      def allow_edit(from, to)
        from.allow_edit(self, to)
      end

      #
      # Prevent a sharer to edit the resource. First parameter is to set same
      # format of allow_edit.
      #
      # == Parameters:
      # from::
      #   Sharer that want to allow another to edit resource
      # to::
      #   Sharer that will be able to edit the resource
      #
      # == Returns:
      # True if it's ok
      #
      def prevent_edit(from, to)
        from.prevent_edit(self, to)
      end
    end
  end
end
