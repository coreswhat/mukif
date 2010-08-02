

  # given
  
    Given /^I am on the '(.*)'$/ do |page_name| 
      visit path_to(page_name)
    end   

  # when
    
    When /^I go to the '(.*)'$/ do |page_name| 
      visit path_to(page_name)
    end
    
    When /^I fill in '(.*)' with '(.*)'$/ do |field, value|
      fill_in(field, :with => value)
    end
    
    When /^I fill in file field '(.*)' with '(.*)'$/ do |field, file_name|    
      attach_file field, File.join(TEST_DATA_DIR, file_name)
    end    
    
    When /^I select '(.*)' from '(.*)'$/ do |value, select|
      select(value, :from => select)
    end 
    
    When /^I check '(.*)'$/ do |check_box|
      check(check_box)
    end 
    
    When /^I uncheck '(.*)'$/ do |check_box|
      uncheck(check_box)
    end  

    When /^I click link '(.*)'$/ do |link_name|
      if Capybara.current_driver == :selenium
        page.evaluate_script('window.confirm = function() { return true; }')
      end
      within(:css, 'div#application') do 
        click_link(link_name)
      end
    end
    
    When /^I click button '(.*)'$/ do |button_name|
      if Capybara.current_driver == :selenium
        page.evaluate_script('window.confirm = function() { return true; }')
      end
      within(:css, 'div#application') do
        click_button(button_name)
      end
    end

    When /^I click user box link '(.*)'$/ do |link_name|
      page.evaluate_script('window.confirm = function() { return true; }')
      within(:css, 'div#user_box') do 
        click_link(link_name)
      end
    end 
    
  # then

    Then /^page should countain text '(.*)'$/ do |text|
      body.should include(text)
    end

    Then /^page should not countain text '(.*)'$/ do |text|
      body.should_not include(text)
    end

    Then /^page should countain link '(.*)'$/ do |link|
      has_link?(link).should be_true
    end

    Then /^page should not countain link '(.*)'$/ do |link|
      has_link?(link).should be_false
    end
    
    

    



#