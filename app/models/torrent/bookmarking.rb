
class Torrent < ActiveRecord::Base

  # bookmarking concern

  def self.set_bookmarked_batch(user, torrents)
    return if torrents.blank?
    unless user.bookmarks.blank?
      torrents.each do |t|
        t.bookmarked = true if user.bookmarks.detect {|b| b.torrent_id == t.id }
      end
    end
  end

  def set_bookmarked(user)
    self.bookmarked = true if self.bookmarks.find_by_user_id user
  end  
  
  def bookmarked?
    self.bookmarked
  end
  
  def bookmark_unbookmark(user)
    b = self.bookmarks.find_by_user_id user
    if b
      b.destroy
      self.bookmarked = false
    else
      b = Bookmark.create :torrent => self, :user => user
      self.bookmarked = true
    end
  end
end
