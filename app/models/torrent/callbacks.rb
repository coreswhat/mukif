
class Torrent < ActiveRecord::Base

  # callbacks concern

  before_save :trim_description
  
  after_create :create_fulltext!
  
  after_update :update_fulltext!

  private

    def trim_description
      self.description = self.description[0, 10000] if self.description
    end

    def create_fulltext!
      TorrentFulltext.create! :torrent => self, :name => self.name, :description => self.description
    end

    def update_fulltext!
      if @update_fulltext
        self.torrent_fulltext.name = self.name
        self.torrent_fulltext.description = self.description
        self.torrent_fulltext.save!
      end 
    end
end