
class Post < ActiveRecord::Base

  # callbacks concern

  before_create :init_record
  
  after_create :after_create_routine
  
  before_save :trim_body

  private

    def init_record
      self.post_number = self.topic.posts_count + 1
    end
    
    def after_create_routine
      self.topic.increment :posts_count
      self.topic.last_post_at = Time.now
      self.topic.last_post_by = user.username
      self.topic.save!
    end
    
    def trim_body
      self.body = self.body[0, 4000]
    end
end