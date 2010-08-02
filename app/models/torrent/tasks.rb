
class Torrent < ActiveRecord::Base

  # tasks concern

  def self.reset_expired_free_period
    connection.execute 'UPDATE torrents SET free = FALSE, free_until = NULL WHERE free_until < NOW()'
  end
end