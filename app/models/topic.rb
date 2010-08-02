
class Topic < ActiveRecord::Base

  belongs_to :user
  belongs_to :forum
  
  has_one :topic_fulltext, :dependent => :destroy
  
  has_many :posts, :dependent => :destroy  
    
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.topic.errors.attributes.#{attribute.to_s}.#{key}", args)
  end
end
