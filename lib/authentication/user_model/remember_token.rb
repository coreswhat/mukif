
module Authentication
  
  module UserModel
    
    module RememberToken
  
      def self.included(recipient)
        recipient.extend(ModelClassMethods)  
        
        recipient.class_eval do
          include ModelInstanceMethods
        end
      end
  
      module ModelInstanceMethods
                
        def remember_me_for(period)
          self.remember_token = User.make_token
          self.remember_token_expires_at = period.from_now
          save(false)
        end
  
        def clear_remember_token!
          self.remember_token = nil
          self.remember_token_expires_at = nil
          save(false)
        end
      end
      
      module ModelClassMethods    
                    
        def authenticate_by_remember_token(remember_token)
          unless remember_token.blank?
            u = User.find_by_remember_token remember_token
            if u && u.active?
              return u if u.remember_token_expires_at && u.remember_token_expires_at > Time.now
            end
          end
          nil
        end
      end
    end
  end
end

