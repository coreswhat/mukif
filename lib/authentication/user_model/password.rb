
module Authentication
  
  module UserModel
      
    module Password
  
      def self.included(recipient)
        recipient.extend(ModelClassMethods)  
        
        recipient.class_eval do
          include ModelInstanceMethods
          
          before_save :encrypt_password
          
          attr_accessor :password
        end
      end
  
      module ModelInstanceMethods      
  
        def authenticated?(password)
          self.crypted_password == User.encrypt_password(password, self.salt)
        end
        
        def encrypt_password
          self.salt = User.make_token if self.salt.blank?
          unless password.blank?
            self.crypted_password = User.encrypt_password(password, self.salt)
          end 
        end
      end
      
      module ModelClassMethods
                
        def authenticate(username, password)
          u = find_by_username username
          u && u.authenticated?(password) ? u : nil
        end
      end
    end
  end
end
