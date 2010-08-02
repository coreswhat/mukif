
class Topic < ActiveRecord::Base

  # callbacks concern

  before_create :init_record
  
  after_create :create_fulltext!, :after_create_routine 
  
  before_save :trim_body
  
  after_update :update_fulltext!

  after_destroy :after_destroy_routine

  private

    def init_record
      self.last_post_at = Time.now
      self.topic_number = self.forum.topics_count + 1
    end
    
    def after_create_routine 
      self.forum.increment :topics_count
      self.forum.save!
    end

    def after_destroy_routine
      self.forum.decrement :topics_count
      self.forum.save!
    end

    def create_fulltext!
      TopicFulltext.create! :topic => self, :title => self.title, :body => self.body
    end

    def update_fulltext!
      if @update_fulltext
        self.topic_fulltext.title = self.title
        self.topic_fulltext.body = self.body
        self.topic_fulltext.save!
      end
    end
    
    def trim_body
      self.body = self.body[0, 10000]
    end
end