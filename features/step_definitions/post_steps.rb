
  # given

    Given /the following posts exist:/ do |t|
      t.hashes.each do |h|
        make_post find_forum_by_name(h['forum']), find_topic_by_title(h['topic']), find_user_by_username(h['creator']), h['body']
      end
    end 

  # then
    
    Then /^post with body '(.*)' should exist with attributes:$/ do |body, table|      
      p = find_post_by_body body
      p.should_not be_nil
            
      post_table = [ ['forum', 'topic', 'creator'], [p.forum.name, p.topic.title, p.user.username] ] 
      table.diff!(post_table)
    end

