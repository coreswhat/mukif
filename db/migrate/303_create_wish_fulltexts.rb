
class CreateWishFulltexts < ActiveRecord::Migration

  def self.up
    create_table :wish_fulltexts do |t|
      t.column :wish_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :description, :text
    end

    execute 'ALTER TABLE wish_fulltexts ENGINE = MyISAM'
    execute 'CREATE FULLTEXT INDEX wish_fulltext_index ON wish_fulltexts (name, description)'
  end

  def self.down
    drop_table :wish_fulltexts
  end
end