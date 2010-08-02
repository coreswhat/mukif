
class User < ActiveRecord::Base

  # callbacks concern

  before_create :init_new_record
  
  before_save :trim_info, :squeeze_extra_tickets
  
  before_destroy :ensure_not_system

  private

    def init_new_record
      self.role = Role.find_by_name(Role::USER) unless self.role
      self.reset_passkey
      self.style = Style.find(:first) unless self.style
    end

    def trim_info
      self.info = self.info[0, 4000] if self.info
    end
    
    def squeeze_extra_tickets
      self.extra_tickets = self.extra_tickets.squeeze(' ') if self.extra_tickets
    end

    def ensure_not_system
      raise ArgumentError if self.id == 1
    end
end