
Feature: Wish Browsing
  In order to se existing wishes
  As a registered user
  I want to be able to browse them
  
  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And I am logged in as 'joe-the-user'

  Scenario: User browses wishes using pagination links
    Given the following wishes exist:
      | name                     | wisher       |
      | joe_the_users_wish       | joe-the-user |
      | joe_the_users_wish_two   | joe-the-user |
      | joe_the_users_wish_three | joe-the-user |
    When I go to the 'wishes page'
      And I click link '03 - 03'
    Then page should countain text '03 - 03'
      And page should not countain link '03 - 03'
      And page should countain link '01 - 02'