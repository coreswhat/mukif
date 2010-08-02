
class BgTask < ActiveRecord::Base

  # finders concern
  
  def self.all
    find :all, :order => 'name'
  end
end