
class Role < ActiveRecord::Base

  # validation concern
  
  validates_presence_of :name, :css_class, :description  
  validates_uniqueness_of :name, :case_sensitive => false, :message => 'duplicated name!'
end