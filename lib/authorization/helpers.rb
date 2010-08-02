
module Authorization
  
  module Helpers
  
    def ticket_required(ticket)
      logger.debug ':-) authorization.helpers.ticket_required'
      access_denied unless current_user.has_ticket? ticket
    end
  
    def owner_required
      logger.debug ':-) authorization.helpers.owner_required'
      access_denied unless current_user.owner?
    end
  
    def admin_required
      logger.debug ':-) authorization.helpers.admin_required'
      access_denied unless current_user.admin?
    end
  
    def admin_mod_required
      logger.debug ':-) authorization.helpers.admin_mod_required'
      access_denied unless current_user.admin_mod?
    end
    
    def staff_required
      logger.debug ':-) authorization.helpers.staff_required'
      access_denied unless current_user.staff?
    end
  
    def access_denied
      logger.debug ':-o authorization.helpers.access_denied'
      raise Authorization::AccessDeniedError
    end
  end 
end 