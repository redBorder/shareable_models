#
# Create share resources model in database
#
class CreateShareModels < ActiveRecord::Migration
  def change
    create_table :share_models do |t|
      # Sahred resource
      t.references :resource, polymorphic: true, index: true
      # Model who will receive resource
      t.references :shared_to, polymorphic: true, index: true
      # Model who share the resource
      t.references :shared_from, polymorphic: true, index: true
      # Edit permissions
      t.boolean :edit
    end
  end
end
