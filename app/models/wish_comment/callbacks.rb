
class WishComment < ActiveRecord::Base

  # callbacks concern
  
  before_create :init_record
  
  after_create :after_create_routine
  
  before_save :trim_body

  private

    def init_record
      self.comment_number = self.wish.comments_count + 1
    end
    
    def after_create_routine
      self.wish.increment! :comments_count
    end

    def trim_body
      self.body = self.body[0, 2000]
    end
end