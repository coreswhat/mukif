
class CreateTypes < ActiveRecord::Migration

  def self.up
    create_table :types do |t|
      t.column :description, :string, :null => false
      t.column :image, :string
      t.column :position, :integer, :null => false
    end
  end

  def self.down
    drop_table :types
  end
end
