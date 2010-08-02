
  # given

    Given /the following topics exist:/ do |t|
      t.hashes.each do |h|
        make_topic find_forum_by_name(h['forum']), find_user_by_username(h['creator']), h['title'], h['body']
      end
    end 

  # then

    Then /^topic with title '(.*)' should exist with attributes:$/ do |title, table|
      t = find_topic_by_title(title)
      t.should_not be_nil
            
      topic_table = [ ['forum', 'creator', 'body'], [t.forum.name, t.user.username, t.body] ] 
      table.diff!(topic_table)
    end
    
