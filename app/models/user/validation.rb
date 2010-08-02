
class User < ActiveRecord::Base

  # validation concern
    # check 'updating' concern for validations on update

  def validate
    validate_counters
  end  
  
  def validate_on_create
    validate_username
    validate_password
    validate_email
  end  

  def self.valid_username?(username)
    username =~ /\A[\w_\-]+\Z/
  end

  def self.valid_email?(email)
    email =~ /\A[\w\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z0-9]+)\Z/i
  end

  private

    def validate_username
      if self.username.blank?
        add_error :username, 'required'
      elsif !(3..20).include?(self.username.size)
        add_error :username, 'invalid_size'
      elsif !User.valid_username?(self.username)
        add_error :username, 'invalid_format'
      else
        c = new_record? ? nil : ['id != ?', self.id] 
        add_error :username, 'taken' if User.find_by_username self.username, :conditions => c      
      end
    end

    def validate_password
      if self.crypted_password.blank? && self.password.blank?
        add_error :password, 'required'
      elsif !self.password.blank?
        if !(5..40).include?(self.password.size)
          add_error :password, 'invalid_size'
        elsif self.password != self.password_confirmation
          add_error :password_confirmation, 'invalid_confirmation'
        end
      end
    end

    def validate_email
      if self.email.blank?
        add_error :email, 'required'
      elsif !(1..100).include?(self.email.size)
        add_error :email, 'invalid_size'
      elsif !User.valid_email?(self.email)
        add_error :email, 'invalid_format'
      else
        c = new_record? ? nil : ['id != ?', self.id] 
        add_error :email, 'taken' if User.find_by_email self.email, :conditions => c              
      end
    end
    
    def validate_counters
      raise 'user uploaded cannot be negative!' if self.uploaded < 0
      raise 'user downloaded cannot be negative!' if self.downloaded < 0
    end
end



