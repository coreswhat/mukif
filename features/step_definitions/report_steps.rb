
  # then
      
    Then /^a report for user '(.*)' with reason '(.*)' should exist$/ do |username, reason|
      r = find_report_by_target_and_reason find_user_by_username(username), reason
      r.should_not be_nil
      r.target_path.should == path_to("user details page for user \"#{username}\"")
    end
    
    Then /^a report for torrent '(.*)' with reason '(.*)' should exist$/ do |torrent_name, reason|
      r = find_report_by_target_and_reason find_torrent_by_name(torrent_name), reason
      r.should_not be_nil
      r.target_path.should == path_to("torrent details page for torrent \"#{torrent_name}\"")
    end
    
    Then /^a report for comment '(.*)' with reason '(.*)' should exist$/ do |comment_body, reason|
      r = find_report_by_target_and_reason find_comment_by_body(comment_body), reason
      r.should_not be_nil
      r.target_path.should == path_to("comment details page for comment \"#{comment_body}\"")
    end    
    
    Then /^a report for wish '(.*)' with reason '(.*)' should exist$/ do |wish_name, reason|
      r = find_report_by_target_and_reason find_wish_by_name(wish_name), reason
      r.should_not be_nil
      r.target_path.should == path_to("wish details page for wish \"#{wish_name}\"")
    end
    
    Then /^a report for wish comment '(.*)' with reason '(.*)' should exist$/ do |wish_comment_body, reason|
      r = find_report_by_target_and_reason find_wish_comment_by_body(wish_comment_body), reason
      r.should_not be_nil
      r.target_path.should == path_to("wish comment details page for wish comment \"#{wish_comment_body}\"")
    end    
    
    Then /^a report for topic '(.*)' with reason '(.*)' should exist$/ do |topic_title, reason|      
      r = find_report_by_target_and_reason find_topic_by_title(topic_title), reason
      r.should_not be_nil
      r.target_path.should == path_to("topic details page for topic \"#{topic_title}\"")
    end
    
    Then /^a report for post '(.*)' with reason '(.*)' should exist$/ do |post_body, reason|      
      r = find_report_by_target_and_reason find_post_by_body(post_body), reason
      r.should_not be_nil
      r.target_path.should == path_to("post details page for post \"#{post_body}\"")
    end