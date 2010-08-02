
class Torrent < ActiveRecord::Base

  # moderation concern

  def inactivate!(inactivator, reason)
    Torrent.transaction do      
      log_inactivation inactivator, reason
      notify_inactivation(inactivator, reason) if self.user && self.user != inactivator
      self.active = false
      save!
      logger.debug ':-) torrent inactivated' if logger
    end
  end

  def activate!(activator)
    Torrent.transaction do
      log_activation activator
      notify_activation activator if self.user && self.user != activator
      self.active = true
      save!
      logger.debug ':-) torrent activated' if logger
    end
  end

  def destroy_with_notification(destroyer, reason)
    Torrent.transaction do    
      log_destruction(destroyer, reason)
      notify_destruction(destroyer, reason) if self.user && self.user != destroyer
      destroy
      logger.debug ':-) torrent destroyed' if logger
    end
  end  
end