
Feature: User Browsing
  In order to se existing users
  As a registered user
  I want to be able to browse them
  
  Background:    
    Given the following users exist:
      | username           | role |
      | joe-the-user       | user |
      | joe-the-user_two   | user |
      | joe-the-user_three | user |
      And I am logged in as 'joe-the-user'

  Scenario: User browses users using pagination links
    When I go to the 'users page'
      And I click link '03 - 03'
    Then page should countain text '03 - 03'
      And page should not countain link '03 - 03'
      And page should countain link '01 - 02'