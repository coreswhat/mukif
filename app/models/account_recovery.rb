
class AccountRecovery < ActiveRecord::Base
  
  belongs_to :user
  
  validates_uniqueness_of :code

  def self.make_code
    Digest::MD5.hexdigest(rand.to_s).upcase
  end
  
  def self.delete_all_by_user(user)
    delete_all ['user_id = ?', user.id]
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
  end
  
  def self.kreate!(user)
    create! :user => user, :code => self.class.make_code
  end
end
