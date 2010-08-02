
class Message < ActiveRecord::Base

  # delivering concern

  def deliver
    self.unread = true
    self.folder = INBOX
    if valid?
      Message.transaction do
        unless self.sender.system?
          delete_replied! if self.sender.delete_on_reply? && !self.replied_id.blank?     
          save_sent! if self.sender.save_sent?
        end
        unless self.owner.has_new_message?
          self.owner.toggle :has_new_message
          self.owner.save!
        end 
        save
      end
      return true
    end
    false
  end
  
  def self.deliver_system_message!(receiver, subject, body)
    begin
      m = new
      m.owner = m.receiver = receiver
      m.sender = User.system_user
      m.subject = subject
      m.body = body
      if m.deliver
        logger.debug ":-) system notification '#{subject}' sent to #{receiver.username}" if logger
      else
        raise 'system message delivery failed!'
      end
    rescue => e
      ErrorLog.kreate_with_error! e # not critical, just log the error
    end
  end
  
  private

    def save_sent!
      clone = self.clone
      clone.owner = self.sender
      clone.folder = SENT
      clone.save!
    end    

    def delete_replied!
      m = Message.find self.replied_id
      m.ensure_ownership self.sender
      m.folder = TRASH
      m.save!
    end
end
