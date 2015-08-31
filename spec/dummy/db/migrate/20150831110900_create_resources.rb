# Create resources
class CreateResources < ActiveRecord::Migration
  def change
    create_table(:resources) do |t|
      t.string :name
      t.references :user, index: true
    end
  end
end
