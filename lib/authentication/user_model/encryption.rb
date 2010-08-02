
module Authentication
  
  module UserModel
      
    module Encryption
  
      def self.included(recipient)
        recipient.extend(ModelClassMethods)  
      end

      module ModelClassMethods
  
        def encrypt_password(password, salt)
          crypt = digest = Authentication::PASSWORD_DIGEST_KEY

          Authentication::PASSWORD_DIGEST_STRETCHES.times do
            crypt = secure_digest(crypt, salt, password, digest)
          end
          crypt
        end
        
        def secure_digest(*args)
          Digest::SHA1.hexdigest(args.flatten.join('--'))
        end
    
        def make_token
          secure_digest(Time.now, (1..10).map{ rand.to_s })
        end      
      end
    end
  end
end
