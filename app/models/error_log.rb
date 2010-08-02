
class ErrorLog < ActiveRecord::Base

  belongs_to :user
  
  before_save :trim_attributes

  def self.all(args)
    find :all, :order => 'created_at DESC', :limit => args[:limit]
  end

  def self.has?
    !find(:first).blank?
  end

  def self.kreate!(message, location, user = nil)
    create! :message => message, :location => location, :user => user
  end

  def self.kreate_with_error!(e, user = nil)
    message  = "Tracker Error: #{e.class}\n Message: #{e.clean_message}"    
    location = e.backtrace[0, 15].join("\n")
    kreate! message, location, user
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
  end
  
  private

    def trim_attributes
      self.message = self.message[0, 1000] if self.message
      self.location = self.location[0, 5000] if self.location
    end
end
