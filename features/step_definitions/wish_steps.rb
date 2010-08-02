
  # given

   Given /the following wishes exist:/ do |table|
      table.hashes.each do |h|
        make_wish find_user_by_username(h['wisher']), h['name']
      end
    end
    
    Given /^wish '(.*)' attribute '(.*)' is '(.*)'$/ do |name, attribute, value|
      w = find_wish_by_name name
      w.send(attribute + '=', value)
      w.save!
    end

  # then
  
    Then /^wish '(.*)' should exist with attributes:$/ do |name, table|
      w = find_wish_by_name(name)
      w.should_not be_nil
        
      w_table = [ ['type', 'format', 'wisher', 'description'],
                  [w.type.description, w.format.description, w.user.username, w.description] ] 
      table.diff!(w_table)
    end 

    Then /^the following wishes should exist:$/ do |table|
      a = find_wishes
        
      w_table = [ ['type', 'name', 'format', 'wisher', 'description'] ]
      a.each {|e| w_table << [e.type.description, e.name, e.format.description, e.user.username, e.description] }
      table.diff!(w_table)
    end
    
    Then /^wish '(.*)' should not exist$/ do |name|
      find_wish_by_name(name).should be_nil
    end
    
    Then /^wish '(.*)' attribute '(.*)' should be '(.*)'$/ do |name, attribute, value|
      w = find_wish_by_name name
      w.send(attribute.to_sym).to_s.should == value
    end 






