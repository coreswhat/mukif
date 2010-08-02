
class Role < ActiveRecord::Base
  include Authorization::RoleModel

  # authorization concern
   
  private
   
    def get_role_name
      self.name
    end
   
    def get_role_tickets
      self.tickets
    end  
end