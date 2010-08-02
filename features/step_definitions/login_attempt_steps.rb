
  # given
  
    Given /the following login attempts exist:/ do |t|
      t.hashes.each do |h|
        make_login_attempt(h['ip'], h['count'])
      end
    end   
    
  # then
  
    Then /^the following login attempts should exist:$/ do |table|
      a = find_login_attempts
            
      login_attempts_table = [ ['ip', 'count', 'blocked'] ]
      a.each {|e| login_attempts_table << [e.ip, e.attempts_count.to_s, e.blocked?.to_s] }
      
      table.diff!(login_attempts_table)
    end
  
    Then /^a login attempt for IP '(.*)' should not exist/ do |ip|
      find_login_attempt_by_ip(ip).should be_nil
    end



