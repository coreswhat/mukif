
class Message < ActiveRecord::Base

  FOLDERS = [INBOX, ARCHIVE, SENT, TRASH]
  
  # validation concern
  
  def validate
    validate_folder
    validate_receiver
  end  

  def self.valid_folder?(value)
    FOLDERS.include? value
  end

  private

    def validate_folder      
      unless Message.valid_folder?(self.folder)
        errors.add :folder, 'invalid folder!'
      end
    end

    def validate_receiver
      unless self.receiver
        add_error :receiver_id, 'invalid'
      else 
        if !self.receiver.active?
          add_error :receiver_id, 'inactive'
        elsif self.receiver.system?
          add_error :receiver_id, 'system'
        end
      end
    end
end
