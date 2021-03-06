require 'spec_helper'

describe ShareModel do

  context 'Angel created a resource' do
    before(:each) do
      @resource = resources(:angel_resource)
      @angel = users(:angel)
      @clara = users(:clara)
      @jose = users(:jose)
    end

    it 'has read and edit permissions' do
      expect(@resource.editable_by?(@angel)).to be true
      expect(@resource.readable_by?(@angel)).to be true
      expect(@angel.can_edit?(@resource)).to be true
      expect(@angel.can_read?(@resource)).to be true

      # Check for Clara
      expect(@resource.editable_by?(@clara)).to be false
      expect(@resource.readable_by?(@clara)).to be false
      expect(@clara.can_edit?(@resource)).to be false
      expect(@clara.can_read?(@resource)).to be false
    end

    it 'can allow an user to read the report (Sharer model)' do
      expect(@clara.can_read?(@resource)).to be false
      expect(@clara.can_edit?(@resource)).to be false
      # Invite the user from sharer model
      expect(@angel.share(@resource, @clara)).to be true
      expect(@clara.can_read?(@resource)).to be true
      expect(@clara.can_edit?(@resource)).to be false
    end

    it 'can allow an user to read the report (Shareable model)' do
      @resource.shared_with.destroy_all
      # Invite the user from sharer model
      expect(@resource.share_it(@angel, @clara)).to be true
      expect(@resource.readable_by?(@clara)).to be true
      expect(@resource.editable_by?(@clara)).to be false
    end

    it 'can allow an user to edit the report (Sharer model)' do
      @resource.shared_with.destroy_all
      # Invite the user from sharer model
      expect(@angel.allow_edit(@resource, @clara)).to be true
      expect(@clara.can_read?(@resource)).to be true
      expect(@clara.can_edit?(@resource)).to be true
    end

    it 'can allow an user to edit the report (Shareable model)' do
      @resource.shared_with.destroy_all
      # Invite the user from sharer model
      expect(@resource.allow_edit(@angel, @clara)).to be true
      expect(@resource.readable_by?(@clara)).to be true
      expect(@resource.editable_by?(@clara)).to be true
    end

    it 'can prevent edit the report (Sharer model)' do
      @resource.shared_with.destroy_all
      # Invite the user from sharer model
      @resource.allow_edit(@angel, @clara)
      expect(@resource.editable_by?(@clara)).to be true
      @angel.prevent_edit(@resource, @clara)
      expect(@clara.can_edit?(@resource)).to be false
    end

    it 'can prevent edit the report (Shareable model)' do
      @resource.shared_with.destroy_all
      # Invite the user from sharer model
      @resource.allow_edit(@angel, @clara)
      expect(@resource.editable_by?(@clara)).to be true
      @resource.prevent_edit(@angel, @clara)
      expect(@resource.editable_by?(@clara)).to be false
    end

    it 'can not leave the resource he was created' do
      expect(@angel.leave(@resource)).to be false
      expect(@resource.leave_by(@angel)).to be false
    end

    it 'can throw out Jose from resource' do
      expect(@angel.throw_out(@resource, @jose)).to be true
      expect(@resource.shared_with).not_to include(@jose)
    end

    it 'can throw out Jose from resource (from shareable)' do
      expect(@resource.throw_out(@angel, @jose)).to be true
      expect(@resource.shared_with).not_to include(@jose)
    end
  end

  context "Jose hasn't got edit permissions on Angel's resource" do
    before(:each) do
      @resource = resources(:angel_resource)
      @angel = users(:angel)
      @jose = users(:jose)
      @clara = users(:clara)
    end

    it 'has read but no edit permissions' do
      expect(@resource.editable_by?(@jose)).to be false
      expect(@resource.readable_by?(@jose)).to be true
      expect(@jose.can_edit?(@resource)).to be false
      expect(@jose.can_read?(@resource)).to be true
    end

    it 'fail when try to allow an user to read' do
      expect(@resource.share_it(@jose, @clara)).to be false
      expect(@jose.share(@resource, @clara)).to be false
    end

    it 'fail when try to allow an user to edit' do
      expect(@resource.allow_edit(@jose, @clara)).to be false
      expect(@jose.allow_edit(@resource, @clara)).to be false
    end

    it 'fail when try to allow himself to edit' do
      expect(@resource.allow_edit(@jose, @jose)).to be false
      expect(@jose.allow_edit(@resource, @jose)).to be false
    end

    it 'can leave the resource' do
      expect(@jose.leave(@resource)).to be true
      expect(@resource.shared_with).not_to include(@jose)
    end

    it 'can leave the resource (from shareable)' do
      expect(@resource.leave_by(@jose)).to be true
      expect(@resource.shared_with).not_to include(@jose)
    end
  end

  context 'Anyone shared a resource with clara' do
    before(:each) do
      @resource = resources(:angel_resource)
      @clara = users(:clara)
    end

    it 'try to leave the resource' do
      expect(@clara.leave(@resource)).to be true
    end

    it 'try to leave the resource (from shareable)' do
      expect(@resource.leave_by(@clara)).to be true
    end
  end
end
