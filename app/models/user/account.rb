
class User < ActiveRecord::Base

  require 'digest'
  
  # signup concern

  def save_new_with_invitation(invitation_code, invitation_required)
    # new user may have an invitation code even if it is not required
    i = Invitation.find_by_code(invitation_code) unless invitation_code.blank?
    unless i
      if invitation_required
        add_error :invitation_code, (invitation_code.blank? ? 'required' : 'invalid')
        return false
      end
    else
      self.inviter_id = i.user_id
      logger.debug ":-) inviter id: #{self.inviter_id}" if logger
    end
    if save
      logger.debug ":-) user created. id: #{self.id}" if logger
      i.destroy if i
      return true
    end
    false
  end
end











