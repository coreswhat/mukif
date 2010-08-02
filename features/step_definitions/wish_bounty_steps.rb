
  # given
  
   Given /the following wish bounties exist:/ do |table|
      table.hashes.each do |h|
        make_wish_bounty find_wish_by_name(h['wish']), find_user_by_username(h['bounter']), h['amount'], h['revoked']
      end
    end
      
  # then
  
    Then /^the following wish bonties should exist:$/ do |table|
      a = find_wish_bounties
        
      wb_table = [ ['wish', 'bounter', 'amount', 'revoked'] ]
      a.each {|e| wb_table << [e.wish.name, e.user.username, e.amount.to_s, e.revoked.to_s] }
      table.diff!(wb_table)
    end 