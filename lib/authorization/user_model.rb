
module Authorization
  
  module UserModel

    def system?
      get_user_role.system?
    end
  
    def owner?
      get_user_role.owner?
    end
  
    def admin?
      get_user_role.admin?
    end
  
    def mod?
      get_user_role.mod?
    end
  
    def admin_mod?
      admin? || mod?
    end
  
    def defective?
      get_user_role.defective?
    end
  
    def staff?
      admin_mod? || has_ticket?(:staff)
    end
    
    def has_ticket?(ticket)
      get_user_role.has_ticket?(ticket) || has_extra_ticket?(ticket)
    end
    
    def has_extra_ticket?(ticket)
      extra_tickets = get_user_extra_tickets
      extra_tickets && extra_tickets.include?(ticket.to_s)
    end
  
    def add_extra_ticket!(ticket)
      set_user_extra_tickets! "#{get_user_extra_tickets} #{ticket}"
    end
  
    def remove_extra_ticket!(ticket)
      extra_tickets = get_user_extra_tickets
      set_user_extra_tickets! extra_tickets.gsub(ticket.to_s, '') if extra_tickets
    end
  
    private
    
      def get_user_role
        raise NotImplementedError
      end
      
      def get_user_extra_tickets
        raise NotImplementedError
      end
      
      def set_user_extra_tickets!(extra_tickets)
        raise NotImplementedError
      end
  end
end