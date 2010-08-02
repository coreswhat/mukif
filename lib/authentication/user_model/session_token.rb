
module Authentication
  
  module UserModel
    
    module SessionToken
  
      def self.included(recipient)
        recipient.extend(ModelClassMethods) 
        
        recipient.class_eval do
          include ModelInstanceMethods
        end
      end
  
      module ModelInstanceMethods 
        
        def reset_session_token!
          update_attribute :session_token, User.make_token
        end
      
        def clear_session_token!
          update_attribute :session_token, nil
        end
      end
      
      module ModelClassMethods    

        def authenticate_by_session_token(user_id, session_token)
          if !user_id.blank? && !session_token.blank?
            u = find_by_id_and_session_token user_id, session_token
            return u if u && u.active?
          end
          nil
        end
      end      
    end
  end
end