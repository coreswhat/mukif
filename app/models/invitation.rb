
class Invitation < ActiveRecord::Base
  
  belongs_to :user
  
  validates_uniqueness_of :code

  def self.make_code
    Digest::MD5.hexdigest(rand.to_s).upcase[0, 20]
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
  end
  
  def self.kreate!(code, email, user)
    create! :code => code, :email => email, :user => user
  end
end
