
class Peer < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :torrent
  belongs_to :peer_conn

  def connectable?
    self.peer_conn.connectable?
  end

  def completion_percentage
    if self.leftt == 0
      return 100
    elsif self.torrent.size == self.leftt
      return 0
    else
      ((self.torrent.size - self.leftt) / self.torrent.size.to_f) * 100
    end
  end
end


