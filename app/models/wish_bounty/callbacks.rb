
class WishBounty < ActiveRecord::Base

  # callbacks concern

  before_create :init_record
  
  after_create :after_create_routine
  
  after_destroy :after_destroy_routine
  
  private

    def init_record
      self.bounty_number = self.wish.bounties_count + 1
    end

    def after_create_routine
      self.user.charge! self.amount

      self.wish.lock!
      self.wish.increment :bounties_count
      self.wish.total_bounty += self.amount
      self.wish.save!
    end
    
    def after_destroy_routine
      if !revoked? && !self.wish.filled?
        self.user.credit! self.amount
      end
    end
end