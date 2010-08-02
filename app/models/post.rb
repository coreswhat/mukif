
class Post < ActiveRecord::Base
  
  belongs_to :topic
  belongs_to :forum
  belongs_to :user
  
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.post.errors.attributes.#{attribute.to_s}.#{key}", args)
  end
  
  def self.kreate!(topic, user, body)
    create! :forum_id => topic.forum_id, :topic => topic, :user => user, :body => body
  end
end
