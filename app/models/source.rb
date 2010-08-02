
class Source < ActiveRecord::Base

  has_many :torrents, :dependent => :nullify

  validates_presence_of :description
  validates_uniqueness_of :description, :case_sensitive => false, :message => 'duplicated description!'

  def self.all
    find :all, :order => 'position'
  end
end
