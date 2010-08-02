
class BgTask < ActiveRecord::Base

  # validation concern
  
  validates_presence_of :name, :interval_minutes
end