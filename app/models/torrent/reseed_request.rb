
class Torrent < ActiveRecord::Base

  # reseed_request concern
  
  def eligible_for_reseed_request?
    self.snatches_count > 0 && self.seeders_count <= 2
  end

  def request_reseed(requester, cost, notifications_number)
    Torrent.transaction do
      requester.charge! cost

      notify_reseed_request self.user, requester if self.user

      snatches = Snatch.find_all_by_torrent_id self, :order => 'created_at DESC', :limit => notifications_number
      snatches.each {|s| notify_reseed_request s.user, requester }
    end
  end
end