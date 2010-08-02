
class Role < ActiveRecord::Base
  
  has_many :users

  attr_protected :name
end
