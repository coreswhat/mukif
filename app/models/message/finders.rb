
class Message < ActiveRecord::Base

  # finders concern

  def self.paginate_user_messages(u, args)
    paginate_by_owner_id u,
                         :conditions => {:folder => args[:folder]},
                         :order => 'created_at DESC',
                         :page => args[:page],
                         :per_page => args[:per_page]
  end
end