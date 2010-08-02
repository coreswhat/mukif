
class Message < ActiveRecord::Base

  INBOX, ARCHIVE, SENT, TRASH = 'inbox', 'archive', 'sent', 'trash'

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  attr_accessor :replied_id # message being replied 
  
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.message.errors.attributes.#{attribute.to_s}.#{key}", args)
  end 
  
  def set_as_read!
    toggle! :unread if unread?
  end

  def move_to_folder!(folder, mover)
    ensure_ownership mover
    self.folder = folder
    save!
  end

  def self.new_for_view(sender, args)
    m = new
    unless args[:to].blank?
      m.receiver = User.find_by_username(args[:to])
    end
    unless args[:message_id].blank? # if replying or forwarding
      message = find args[:message_id]
      message.ensure_ownership sender
      prepare_for_reply m, message if args[:reply]
      prepare_for_forward m, message if args[:forward]
    end
    m
  end
  
  def self.new_for_delivery(sender, params, args)
    m = new params
    m.owner = m.receiver = User.find_by_username(args[:to])
    m.sender = sender
    m.replied_id = args[:replied_id]
    m
  end

  private

    def self.prepare_for_reply(m, old_message)
      m.receiver = old_message.sender
      m.replied_id = old_message.id
      prefix = I18n.t('m.message.prepare_for_reply.prefix')
      wrote = I18n.t('m.message.prepare_for_reply.wrote')
      m.subject = "#{ "#{prefix} " unless old_message.subject.starts_with?(prefix) }#{old_message.subject}"
      m.body = "\n\n\n----
                \n#{old_message.sender.username} #{wrote}
                \n\n#{old_message.body}"
    end

    def self.prepare_for_forward(m, old_message)
      prefix = I18n.t('m.message.prepare_for_forward.prefix')
      wrote = I18n.t('m.message.prepare_for_forward.wrote')
      m.subject = "#{ "#{prefix} " unless old_message.subject.starts_with?(prefix) }#{old_message.subject}"
      m.body = "\n\n\n----
               \n#{old_message.sender.username} #{wrote}:
               \n\n#{old_message.body}"
    end
end
