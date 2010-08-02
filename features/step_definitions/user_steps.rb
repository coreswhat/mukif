  
  # given
  
    Given /the following users exist:/ do |table|
      table.hashes.each do |h|
        make_user h['username'], fetch_role(h['role'])
      end
    end
  
    Given /^the system user exists$/ do
      make_system_user
    end
    
    Given /^user '(.*)' attribute '(.*)' is '(.*)'$/ do |username, attribute, value|
      u = find_user_by_username username
      u.send(attribute + '=', value)
      u.save!
    end      

  # then
      
    Then /^user '(.*)' should exist with attributes:$/ do |username, table|
      u = find_user_by_username(username)
      u.should_not be_nil
                  
      u_table = [ ['email', 'inviter'], [u.email, (u.inviter ? u.inviter.username : '')] ] 
      table.diff!(u_table)
    end  
    
    Then /^the following users should exist:$/ do |table|
      a = find_users
      a.delete_if {|e| e.system? }

      u_table = [ ['username', 'email', 'style', 'gender', 'country', 'avatar', 'info'] ]
      a.each {|e| u_table << [e.username, 
                              e.email, 
                              (e.style ? e.style.description : ''), 
                              (e.gender ? e.gender.description : ''),
                              (e.country ? e.country.description : ''),
                              e.avatar, e.info] }
      table.diff!(u_table)
    end
     
    Then /^user '(.*)' should not exist$/ do |username|
      find_user_by_username(username).should be_nil
    end

    Then /^privacy settings for user '(.*)' should be:$/ do |username, table|
      u = find_user_by_username(username)
      u.should_not be_nil
                  
      u_table = [ ['show last seen', 'show uploads', 'show snatches', 'show seeding', 'show leeching'],
                  [u.display_last_request_at.to_s, u.display_uploads.to_s, u.display_snatches.to_s, u.display_seeding.to_s, u.display_leeching.to_s ] ] 
      table.diff!(u_table)
    end 
    
    Then /^messenger settings for user '(.*)' should be:$/ do |username, table|
      u = find_user_by_username(username)
      u.should_not be_nil
                  
      u_table = [ ['save sent', 'delete on reply'], [u.save_sent.to_s, u.delete_on_reply.to_s ] ] 
      table.diff!(u_table)
    end 
  
    Then /^user '(.*)' attribute '(.*)' should be '(.*)'$/ do |username, attribute, value|
      u = find_user_by_username username
      u.send(attribute.to_sym).to_s.should == value
    end    
    
    Then /^user '(.*)' attribute '(.*)' should not be '(.*)'$/ do |username, attribute, value|
      u = find_user_by_username username
      u.send(attribute.to_sym).to_s.should_not == value
    end   
    
    

