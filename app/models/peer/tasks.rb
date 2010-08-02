
class Peer < ActiveRecord::Base

  # tasks concern

  def self.destroy_inactives(threshold)
    destroy_all ['last_action_at < ?', threshold]
  end
end