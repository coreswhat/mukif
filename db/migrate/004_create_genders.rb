
class CreateGenders < ActiveRecord::Migration

  def self.up
    create_table :genders do |t|
      t.column :description, :string, :null => false
    end
  end

  def self.down
    drop_table :genders
  end
end
