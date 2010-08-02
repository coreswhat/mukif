
class Wish < ActiveRecord::Base

  # filling concern
  
  def self.torrent_taken?(t)
    !find_by_torrent_id(t).blank?
  end

  def fill!(t)
    raise 'cannot fill a wish that is not open!' unless open?
    raise 'torrent already used to fill another wish!' if self.class.torrent_taken?(t)
    
    self.pending = true
    
    self.torrent = t
    self.filler = self.torrent.user
    self.filled_at = Time.now
    save!
  end

  def approve!(approver)
    Wish.transaction do
      self.pending = false
      self.filled = true
      self.approver = approver
      self.save!

      self.filler.lock!
      self.filler.uploaded += self.total_bounty
      self.filler.save!

      log_approval
      notify_approval
    end
  end

  def reject!(rejecter, reason)
    Wish.transaction do
      notify_rejection rejecter, reason

      self.pending = false
      self.torrent_id = nil
      self.filler_id = nil
      self.filled_at = nil
      save!
    end
  end
end