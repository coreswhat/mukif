
class User < ActiveRecord::Base

  # administration concern
  
  def inactivate!
    self.active = false
    save!
  end

  def activate!
    self.active = true
    save
  end

  def destroy_with_log(destroyer)
    destroy
    log_destruction(destroyer)
    logger.debug ':-) user destroyed' if logger
  end  
end
