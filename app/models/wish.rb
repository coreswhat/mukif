
class Wish < ActiveRecord::Base

  has_many :wish_bounties, :dependent => :destroy
  
  has_one  :wish_fulltext, :dependent => :destroy
  
  belongs_to :torrent
  belongs_to :user
  belongs_to :filler, :class_name => 'User'
  belongs_to :approver, :class_name => 'User'
  belongs_to :type
  belongs_to :format
  belongs_to :country
  
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.wish.errors.attributes.#{attribute.to_s}.#{key}", args)
  end 
  
  def open?
    !filled? && !pending?
  end

  def status
    case
      when filled?
        I18n.t('m.wish.status.filled')
      when pending?
        I18n.t('m.wish.status.pending')
      else
        I18n.t('m.wish.status.open')
    end
  end

  def destroy_with_notification(destroyer, reason)
    Wish.transaction do
      notify_destruction(destroyer, reason) if destroyer != self.user
      log_destruction destroyer, reason
      destroy
    end
  end
end

