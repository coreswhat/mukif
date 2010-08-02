
class User < ActiveRecord::Base

  require 'digest'
  
  # account recovering concern

  def reset_password(password, confirmation)
    if password.blank?
      add_error :password, 'required'
    else
      self.password = password
      self.password_confirmation = confirmation
      validate_password
    end
    errors.empty? ? save : false
  end
end