
class CreateFormats < ActiveRecord::Migration
     
  def self.up
    create_table :formats do |t|
      t.column :description, :string, :null => false
      t.column :position, :integer, :null => false
    end
  end

  def self.down
    drop_table :formats
  end
end
