# Create users
class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name
    end
  end
end
