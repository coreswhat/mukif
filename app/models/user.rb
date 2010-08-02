

class User < ActiveRecord::Base
  
  attr_protected :role_id, :tickets

  has_many :torrents, :dependent => :nullify
  has_many :peers, :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  has_many :snatches, :dependent => :nullify
  has_many :comments, :dependent => :nullify
  has_many :messages, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :invitations, :dependent => :destroy, :order => 'created_at DESC'
  has_many :invitees, :class_name => 'User', :foreign_key => 'inviter_id', :dependent => :nullify
  has_many :announce_logs, :dependent => :destroy
  has_many :error_logs, :dependent => :nullify
  has_many :account_recoveries, :dependent => :destroy
  has_many :topics, :dependent => :nullify
  has_many :posts, :dependent => :nullify
  has_many :wishes, :dependent => :nullify
  has_many :filled_wishes, :class_name => 'Wish', :foreign_key => 'filler_id', :dependent => :nullify
  has_many :approved_wishes, :class_name => 'Wish', :foreign_key => 'approver_id', :dependent => :nullify
  has_many :wish_bounties, :dependent => :nullify
  
  belongs_to :role
  belongs_to :country
  belongs_to :gender
  belongs_to :style
  belongs_to :inviter, :class_name => 'User', :foreign_key => 'inviter_id'
  
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.user.errors.attributes.#{attribute.to_s}.#{key}", args)
  end

  def register_access
    if self.last_request_at.blank? || self.last_request_at < 3.minutes.ago
      update_attribute :last_request_at, Time.now
    end
  end

  def default_types_a
    self.default_types.blank? ? [] : self.default_types.split(' ')
  end

  def charge!(amount)
    lock!
    self.uploaded -= amount
    save!
  end

  def credit!(amount)
    lock!
    self.uploaded += amount
    save!
  end
end












