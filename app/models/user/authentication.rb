
class User < ActiveRecord::Base
  include Authentication::UserModel::Encryption 
  include Authentication::UserModel::Password    
  include Authentication::UserModel::RememberToken
  include Authentication::UserModel::SessionToken

  # authentication concern

  attr_accessor :password_confirmation  
end












