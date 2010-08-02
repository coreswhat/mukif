
module Authorization
  
  module RoleModel    
  
    SYSTEM        = 'system'
    OWNER         = 'owner'
    ADMINISTRATOR = 'admin'
    MODERATOR     = 'mod'
    USER          = 'user' 
    DEFECTIVE     = 'defective' 
  
    def has_ticket?(ticket)
      get_role_tickets && get_role_tickets.include?(ticket.to_s)
    end
  
    def reserved?
      true if [SYSTEM, OWNER, ADMINISTRATOR].include? get_role_name
    end
  
    def default?
      true if [SYSTEM, OWNER, ADMINISTRATOR, MODERATOR, USER, DEFECTIVE].include? get_role_name
    end
  
    def is?(role_name)
       get_role_name == role_name
    end
  
    def system?
      is? SYSTEM
    end
  
    def owner?
      (is? OWNER) || system?
    end
  
    def admin?
      (is? ADMINISTRATOR) || owner?
    end
  
    def mod?
      is? MODERATOR
    end
  
    def defective?
      is? DEFECTIVE
    end
    
    private
    
      def get_role_name
        raise NotImplementedError
      end
    
      def get_role_tickets
        raise NotImplementedError
      end
  end
end