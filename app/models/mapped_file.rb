
class MappedFile < ActiveRecord::Base

  belongs_to :torrent

  def self.all_for_torrent(t)
    find_all_by_torrent_id t, :order => :name
  end
end
