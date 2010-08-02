
  # when  
    
    When /^I check default type checkbox for type '(.*)'$/ do |type_name|
      check("types_#{fetch_type(type_name).id}")
    end 
    
  # then
    
    Then /^default types for user '(.*)' should include '(.*)'$/ do |username, type_name|
      u = find_user_by_username username
      u.default_types_a.should include(fetch_type(type_name).id.to_s)
    end 
    
    Then /^default types for user '(.*)' should not include '(.*)'$/ do |username, type_name|
      u = find_user_by_username username
      u.default_types_a.should_not include(fetch_type(type_name).id.to_s)
    end    
