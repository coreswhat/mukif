
class Torrent < ActiveRecord::Base

  # tracker concern

  def total_peers
    self.seeders_count + self.leechers_count
  end
end
