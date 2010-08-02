  
  # given
  
    Given /the following invitations exist:/ do |table|
      table.hashes.each do |h|
        make_invitation find_user_by_username(h['inviter']), h['email'], h['code']
      end
    end  
  
  # then
  
    Then /^the following invitations should exist:$/ do |table|
      a = find_invitations
            
      invitations_table = [ ['inviter', 'email'] ]
      a.each {|e| invitations_table << [e.user.username, e.email] }
      
      table.diff!(invitations_table)
    end 

    Then /^invitation '(.*)' should not exist/ do |code|
      find_invitation_by_code(code).should be_nil
    end
    
    Then /^page should countain the code for invitation with email '(.*)'$/ do |email|
      body.should include(find_invitation_by_email(email).code)
    end    
        
