
class Reward < ActiveRecord::Base

  belongs_to :user
  belongs_to :torrent
      
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.reward.errors.attributes.#{attribute.to_s}.#{key}", args)
  end  
  
  def self.kreate!(torrent, user, amount)
    create! :torrent => torrent, :user => user, :amount => amount
  end
end
