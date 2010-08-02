
class CreateTorrentFulltexts < ActiveRecord::Migration

  def self.up
    create_table :torrent_fulltexts do |t|
      t.column :torrent_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :description, :text
    end

    execute 'ALTER TABLE torrent_fulltexts ENGINE = MyISAM'
    execute 'CREATE FULLTEXT INDEX torrent_fulltext_index ON torrent_fulltexts (name, description)'
  end

  def self.down
    drop_table :torrent_fulltexts
  end
end
