
class PeerConn < ActiveRecord::Base
  has_many :peers

  after_create :debug_created
  
  # Delete peer_conns that don't have any associated peer.
  def self.delete_peerless
    connection.execute 'DELETE FROM peer_conns WHERE peer_conns.id NOT IN (SELECT DISTINCT peer_conn_id FROM peers)'
  end

  private

    def debug_created
      logger.debug ':-) peer conn created' if logger
    end
end
