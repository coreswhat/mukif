
class Style < ActiveRecord::Base

  before_destroy :ensure_not_default

  validates_presence_of :description, :stylesheet
  validates_uniqueness_of :description, :case_sensitive => false, :message => 'duplicated description!'
  validates_uniqueness_of :stylesheet, :case_sensitive => false, :message => 'duplicated stylesheet!'

  def default?
    self.id == 1
  end

  def self.all
    find :all, :order => 'description'
  end

  protected

    def ensure_not_default
      raise ArgumentError, 'default style cannot be deleted' if self.id == 1
    end
end
