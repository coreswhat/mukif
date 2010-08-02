  
  # given
  
    Given /I am logged in as '(.*)'/ do |username|
      Given "I am on the 'login page'"
      When "I fill in \'username\' with \'#{username}\'"
        And "I fill in \'password\' with \'#{username}\'"
        And "I click button \'Login\'"
      Then "page should countain text \'#{username}\'"
        And "page should countain text \'Logout\'"
    end



