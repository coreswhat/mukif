
class Comment < ActiveRecord::Base
    
  belongs_to :user
  belongs_to :torrent

  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.comment.errors.attributes.#{attribute.to_s}.#{key}", args)
  end
  
  def self.kreate!(torrent, user, body)
    create! :torrent => torrent, :user => user, :body => body
  end
end
