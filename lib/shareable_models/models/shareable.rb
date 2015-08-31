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
        check_sharer(from)
        check_sharer(to)
        return false unless editable_by?(from)
        # Store new share of this element
        shared_with.build(
          sharer: from,
          shared_to: to,
          edit: edit
        )
        # Save current model and new shareResource model
        save!
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
        check_sharer(from)
        # Check if the user creates the resource
        return true if shareable_owner.present? && shareable_owner == from
        # Check if this user is assigned to shared_to and edit is true
        shared_with.exists?(shared_to: from, edit: true)
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
        check_sharer(from)
        return true if shareable_owner.present? && shareable_owner == from
        share_resource = shared_with.where(shared_to: from)
        share_resource.empty? ? false : true
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
        return false unless editable_by?(from)
        return true if editable_by?(to)
        share_resource = shared_with.find_by(shared_to: to)
        if share_resource.nil?
          share_it(from, to, true)
        else
          share_resource.update(edit: true)
        end
      end

      #
      # Prevent a sharer to edit the resource. First parameter is to set same format
      # of allow_edit.
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
        return false unless editable_by?(from)
        share_resource = shared_with.find_by(shared_to: to)
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
