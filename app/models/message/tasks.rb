
class Message < ActiveRecord::Base

  # tasks concern

  def self.clear_trash
    delete_all ['folder = ?', TRASH]
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
  end
end