
class BgTask < ActiveRecord::Base

  # reset_expired concern

  def self.reset_expired(params)
    Torrent.reset_expired_free_period
  end
end