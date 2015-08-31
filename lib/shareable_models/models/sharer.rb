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
    module Sharer
      #
      # Method to determine if a model can share and receive elements. It always
      # true because the class include this module.
      #
      # == Returns
      # true
      #
      def sharer?
        true
      end

      #
      # Share a given resource with a sharer model.
      #
      # == Parameters:
      # resource::
      #   Resource to share. It must includes shareable module
      # to::
      #   Model to share the resource. It must includes sharer module
      # edit::
      #   Boolean indicating if it has permissions to edit shared resources.
      #   False by default.
      #
      # == Returns:
      # True if it's saved
      #
      def share(resource, to, edit = false)
        check_resource(resource)
        check_sharer(to)
        return false unless can_edit?(resource)
        # Save new share
        shared_resources.build(
          shared_to: to,
          resource: resource,
          edit: edit
        )
        save!
      end

      #
      # Share the given resource with this model. You can understand this method
      # as inverse of share.
      #
      # == Parameters:
      # resource::
      #   Resource to share. It must includes shareable module
      # from::
      #   Model who share the resource. It must includes sharer module
      # edit::
      #   Boolean indicating if it has permissions to edit shared resources.
      #   False by default.
      #
      # == Returns:
      # True if it's saved
      #
      def share_with_me(resource, from, edit = false)
        check_resource(resource)
        check_sharer(from)
        # Save new share
        from.share(resource, self, edit)
      end

      #
      # Stop sharing a shareable model with a sharer. You can throw out creator
      # of shareable model.
      #
      # == Parameters:
      # resource::
      #   Resource to throw out the sharer.
      # sharer::
      #   Sharer model to disable share.
      # edit::
      #   Check if sharer has permissions to edit before throw out. It's true
      #   by default, but if an user try to leave a resource we must not check
      #   this.
      #
      # == Returns:
      # True if it's ok
      #
      def throw_out(resource, sharer, edit = true)
        check_resource(resource)
        check_sharer(sharer)
        return false if (edit && !self.can_edit?(resource)) ||
                        resource.shareable_owner == sharer
        relation = resource.shared_with.find_by(shared_to: sharer)
        relation.nil? ? true : relation.destroy.destroyed?
      end

      #
      # Current sharer leaves a shareable object.
      #
      # == Parameters:
      # resource::
      #   Resource to throw out the sharer.
      #
      # == Returns:
      # True if it's ok
      #
      def leave(resource)
        throw_out(resource, self, false)
      end

      #
      # Permissions
      # ----------------------------------------------------

      #
      # Check if the current sharer can edit a given resource. We need to check
      # if the user share this element or someone share it with him.
      #
      # == Parameters:
      # resource::
      #   Resource model sharer wants to check
      #
      # == Returns:
      # True or false based on permission
      #
      def can_edit?(resource)
        check_resource(resource)
        resource.shareable_owner == self ||
          shared_with_me.where(edit: true).exists?(edit: true, resource: resource)
      end

      #
      # Check if the current sharer can read a given resource. We need to check if
      # the user share this element or someone share it with him.
      #
      # == Parameters:
      # resource::
      #   Resource model sharer wants to check
      #
      # == Returns:
      # True or false
      #
      def can_read?(resource)
        check_resource(resource)
        resource.shareable_owner == self ||
          shared_with_me.exists?(resource: resource)
      end

      #
      # Allow a sharer to edit the resource
      #
      # == Parameters:
      # resource::
      #   Resource model to allow edit the user
      # to::
      #   Sharer that will be able to edit the resource
      #
      # == Returns:
      # True if it's ok
      #
      def allow_edit(resource, to)
        return false unless can_edit?(resource)
        return true if to.can_edit?(resource)
        share_resource = shared_resources.find_by(shared_to: to, resource: resource)
        if share_resource.nil?
          share(resource, to, true)
        else
          share_resource.update(edit: true)
        end
      end

      #
      # Prevent a sharer to edit the resource. First parameter is to set same
      # format of allow_edit.
      #
      # == Parameters:
      # resource::
      #   Resource to prevent an user to edit
      # to::
      #   Sharer that will be able to edit the resource
      #
      # == Returns:
      # True if it's ok
      #
      def prevent_edit(resource, to)
        return false unless can_edit?(resource)
        share_resource = shared_resources.find_by(shared_to: to, resource: resource)
        return true if share_resource.nil?
        share_resource.update(edit: false)
      end

      private

      #
      # Check if from and destination models have included the modules
      #
      # == Parameters:
      # resource::
      #   Instance of resource to share
      #
      # == Returns:
      # Fail if there are a bad condition
      #
      def check_resource(resource)
        fail "#{resource} class must include Shareable module" unless
          resource.respond_to?(:shareable?)
      end

      #
      # Check if given sharer include the correct module in the class.
      #
      # == Parameters:
      # sharer::
      #   Instance of model to share with
      #
      # == Returns:
      # Fail if the class doesn't include Sharer module
      #
      def check_sharer(sharer)
        fail "#{sharer} class must include Sharer module" unless
          sharer.respond_to?(:sharer?)
      end
    end
  end
end
