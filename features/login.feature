
Feature: Login
  In order to use the system
  As a registered user
  I want to be able to log in

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user | 
      And I am on the 'login page'

  Scenario: User log in
    When I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'joe-the-user'
      And I click button 'Login'
    Then page should countain text 'joe-the-user'
      And page should countain text 'Logout'

  Scenario: User tries to log in with wrong password
    When I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'nononono'
      And I click button 'Login'
    Then page should countain text 'username'
      And page should countain text 'password'
      And page should countain text 'Invalid login data.'
