  
  # given
  
    Given /^a style with description '(.*)' exists$/ do |description|
      fetch_style description
    end
  
    Given /^a type with description '(.*)' exists$/ do |description|
      fetch_type description
    end
  
    Given /^a format with description '(.*)' exists$/ do |description|
      fetch_format description
    end
    
    Given /^a gender with description '(.*)' exists$/ do |description|
      fetch_gender description
    end    
  
    Given /^a source with description '(.*)' exists$/ do |description|
      fetch_source description
    end
    
    Given /^a country with description '(.*)' exists$/ do |description|
      fetch_country description
    end    
