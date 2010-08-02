
Feature: Logout
  In order to stop using the system
  As a registered user
  I want to be able to log out

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user | 
      And I am logged in as 'joe-the-user'
      And I am on the 'homepage'

  Scenario: User logs out
    When I click link 'Logout'
    Then page should countain text 'username'
      And page should countain text 'password'
      And page should countain text 'Please login'

  Scenario: User tries to go to the homepage after logging out
    When I click link 'Logout'
      And I go to the 'homepage'
    Then page should countain text 'username'
      And page should countain text 'password'
      And page should countain text 'Please login'