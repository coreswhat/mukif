
class User < ActiveRecord::Base

  require 'digest'
  
  # tracker concern

  def self.calculate_ratio(up, down)
    down != 0 ? sprintf("%.3f", (up / down.to_f)).to_f : 0
  end

  def reset_passkey
    self.passkey = make_passkey
  end

  def reset_passkey!
    reset_passkey
    save!
  end

  def reset_passkey_with_notification(resetter)
    reset_passkey!
    notify_passkey_resetting if resetter != self
    logger.debug ':-) passkey reset' if logger
  end

  private

    def set_ratio
      self.ratio = User.calculate_ratio(self.uploaded, self.downloaded)
    end

    def make_passkey
      Digest::MD5.hexdigest(rand.to_s).upcase
    end
end