
class TopicFulltext < ActiveRecord::Base
  belongs_to :topic
  
  # note that only topic title and first post are used to search the forums
end
