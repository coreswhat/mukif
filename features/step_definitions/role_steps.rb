  
  # given
  
    Given /^a role with name '(.*)' exists$/ do |name|
      fetch_role name
    end
    
    Given /^role '(.*)' attribute '(.*)' is '(.*)'$/ do |role_name, attribute, value|
      r = fetch_role role_name
      r.send(attribute + '=', value)
      r.save!
    end 