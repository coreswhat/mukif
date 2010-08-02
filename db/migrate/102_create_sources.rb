
class CreateSources < ActiveRecord::Migration

  def self.up
    create_table :sources do |t|
      t.column :description, :string, :null => false
      t.column :position, :integer, :null => false
    end
  end

  def self.down
    drop_table :sources
  end
end
