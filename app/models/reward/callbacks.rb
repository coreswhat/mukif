
class Reward < ActiveRecord::Base

  # callbacks concern

  before_create :init_record
  
  after_create :after_create_routine

  private

    def init_record
      self.reward_number = self.torrent.rewards_count + 1
    end

    def after_create_routine
      self.user.charge! self.amount
      self.torrent.user.credit! self.amount

      self.torrent.lock!
      self.torrent.total_reward += self.amount
      self.torrent.increment :rewards_count
      self.torrent.save!
    end
end