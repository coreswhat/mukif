
class Report < ActiveRecord::Base

  # finders concern

  def self.all
    find :all, :order => 'created_at DESC'
  end

  def self.has_open?
    !find(:first, :conditions => {:handler_id => nil}).blank?
  end
end