
Feature: Wish Deletion
  In order to remove wishs from the site
  As a registered user or a moderator
  I want to be able to delete them

  Background:
    Given the following users exist:
      | username           | role |
      | joe-the-user       | user |
      | joe-the-mod        | mod  | 
      | joe-the-wisher     | user |     
      
  Scenario: User deletes it own wish
    Given I am logged in as 'joe-the-user'
      And the following wishes exist:
        | name               | wisher       |
        | joe_the_users_wish | joe-the-user |
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I click link 'remove'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Remove'
    Then page should countain text 'Request successfully removed.'
      And wish 'joe_the_users_wish' should not exist

  Scenario: Moderator deletes another users wish
    Given I am logged in as 'joe-the-mod'
      And the following wishes exist:
        | name                 | wisher         |
        | joe_the_wishers_wish | joe-the-wisher | 
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'remove'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Remove'
    Then page should countain text 'Request successfully removed.'
      And wish 'joe_the_users_wish' should not exist
      And the following messages should exist: 
        | sender | receiver       | subject         | folder | unread |
        | system | joe-the-wisher | request removed | inbox  | true   | 