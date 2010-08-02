
class WishComment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :wish

  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.wish_comment.errors.attributes.#{attribute.to_s}.#{key}", args)
  end  
  
  def self.kreate!(wish, user, body)
    create! :wish => wish, :user => user, :body => body
  end
end
