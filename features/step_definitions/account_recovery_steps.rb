
  # given

    Given /^the following account recoveries exist:$/ do |t|
      t.hashes.each do |h|
        make_account_recovery find_user_by_username(h['user']), h['code']
      end
    end   
  
  # then
  
    Then /^an account recovery for user '(.*)' should exist$/ do |username|
      r = find_account_recovery_by_user find_user_by_username(username)
      r.should_not be_nil
    end
