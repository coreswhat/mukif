

  # given  
  
    Given /^wish '(.*)' was filled with torrent '(.*)'$/ do |name, torrent_name|
      find_wish_by_name(name).fill! find_torrent_by_name(torrent_name)
    end
    
    Given /^wish '(.*)' had filling approved by '(.*)'$/ do |name, approver_username|
      find_wish_by_name(name).approve! find_user_by_username(approver_username)
    end

  # when

    When /^I paste torrent '(.*)' info hash hex in info_hash$/ do |torrent_name|
      fill_in('info_hash', :with => find_torrent_by_name(torrent_name).info_hash_hex)
    end
    
  # then
  
    Then /^wish '(.*)' should have filling attributes:$/ do |name, table|
      w = find_wish_by_name(name)
      w.should_not be_nil
        
      w_table = [ ['status', 'filler', 'torrent', 'approver'],
                  [w.status, 
                   (w.filler ? w.filler.username : ''), 
                   (w.torrent ? w.torrent.name : ''),
                   (w.approver ? w.approver.username : '')] ] 
      table.diff!(w_table)
    end 