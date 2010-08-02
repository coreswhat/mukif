
class WishBounty < ActiveRecord::Base

  belongs_to :user
  belongs_to :wish

  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.wish_bounty.errors.attributes.#{attribute.to_s}.#{key}", args)
  end 

  def revoke!
    WishBounty.transaction do
      self.user.credit! self.amount

      self.wish.lock!
      self.wish.total_bounty -= self.amount
      self.wish.save!

      self.revoked = true
      save!
    end
  end
  
  def self.kreate!(wish, user, amount)
    create! :wish => wish, :user => user, :amount => amount
  end
end
