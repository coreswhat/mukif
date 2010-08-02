

  # given
 
    Given /^the following wish comments exist:/ do |table|      
      table.hashes.each do |h|
        make_wish_comment find_wish_by_name(h['wish']), find_user_by_username(h['commenter']), h['body']
      end      
    end

  # then
  
    Then /^the following comments for wish '(.*)' should exist:/ do |wish_name, table|
      w = find_wish_by_name wish_name
      
      a = find_wish_comments
      a.delete_if {|e| e.wish != w } 
            
      wc_table = [ ['commenter', 'body'] ]
      a.each {|e| wc_table << [e.user.username, e.body] }
      
      table.diff!(wc_table)
    end
