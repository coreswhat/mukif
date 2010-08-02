
  # given
 
    Given /^the following bookmarks exist:/ do |table|      
      table.hashes.each do |h|
        make_bookmark find_torrent_by_name(h['torrent']), find_user_by_username(h['user'])
      end      
    end

  # then
  
    Then /^bookmark for torrent '(.*)' and user '(.*)' should exist/ do |torrent_name, username|
      b = find_bookmark_by_torrent_and_user find_torrent_by_name(torrent_name), find_user_by_username(username)     
      b.should_not be_nil
    end
    
    Then /^bookmark for torrent '(.*)' and user '(.*)' should not exist/ do |torrent_name, username|
      b = find_bookmark_by_torrent_and_user find_torrent_by_name(torrent_name), find_user_by_username(username)     
      b.should be_nil
    end