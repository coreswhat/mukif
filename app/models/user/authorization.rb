
class User < ActiveRecord::Base
  include Authorization::UserModel
  
  # authorization concern
  
  private
  
    def get_user_role
      self.role
    end
    
    def get_user_extra_tickets
      self.extra_tickets
    end
    
    def set_user_extra_tickets!(extra_tickets)
      self.extra_tickets = extra_tickets
      save!
    end
end












