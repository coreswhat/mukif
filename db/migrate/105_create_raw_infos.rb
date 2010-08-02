
class CreateRawInfos < ActiveRecord::Migration
  
  def self.up
    create_table :raw_infos do |t|
      t.column :torrent_id, :integer, :null => false
      t.column :data, 'mediumblob', :null => false
    end
  end

  def self.down
    drop_table :raw_infos
  end
end