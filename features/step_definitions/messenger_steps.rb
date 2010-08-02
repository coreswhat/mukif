  
  # given
      
    Given /the following messages exist:/ do |t|
      t.hashes.each do |h|
        make_message(find_user_by_username(h['receiver']), find_user_by_username(h['receiver']), find_user_by_username(h['sender']), h['subject'], h['body'], h['folder'])
      end
    end
    
  # when
  
    When /^I check message checkbox for message with subject '(.*)'$/ do |message_subject|
      check("selected_messages_#{find_message_by_subject(message_subject).id}")
    end  
  
  # then

    Then /^the following messages should exist:$/ do |table|
      a = find_messages
            
      messages_table = [ ['sender', 'receiver', 'subject', 'folder', 'unread'] ]
      a.each {|e| messages_table << [e.sender.username, e.receiver.username, e.subject, e.folder, e.unread.to_s] }
      
      table.diff!(messages_table)
    end  
  
    Then /^the following messages with body including '(.*)' should exist:$/ do |partial_body, table|
      a = find_messages
      a.delete_if {|e| !e.body.include?(partial_body) } 
            
      messages_table = [ ['sender', 'receiver', 'subject', 'folder', 'unread'] ]
      a.each {|e| messages_table << [e.sender.username, e.receiver.username, e.subject, e.folder, e.unread.to_s] }
      
      table.diff!(messages_table)
    end
            
  
  
  
  
  
  

