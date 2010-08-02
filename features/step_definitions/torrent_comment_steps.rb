
  # given
 
    Given /^the following torrent comments exist:/ do |table|      
      table.hashes.each do |h|
        make_comment find_torrent_by_name(h['torrent']), find_user_by_username(h['commenter']), h['body']
      end      
    end

  # then
  
    Then /^the following comments for torrent '(.*)' should exist:/ do |torrent_name, table|
      t = find_torrent_by_name torrent_name
      
      a = find_comments
      a.delete_if {|e| e.torrent != t } 
            
      c_table = [ ['commenter', 'body'] ]
      a.each {|e| c_table << [e.user.username, e.body] }
      
      table.diff!(c_table)
    end
