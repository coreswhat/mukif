
class Role < ActiveRecord::Base

  # callbacks concern
    
  before_save :squeeze_tickets
  
  private

    def squeeze_tickets
      self.tickets = self.tickets.squeeze(' ') if self.tickets
    end  
end
