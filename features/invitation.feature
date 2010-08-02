
Feature: Invitation
  In order to invite people to the site
  As a registered user with invitation rights
  I want to be able to send invitations

  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And user 'joe-the-user' attribute 'extra_tickets' is 'inviter'
      And that signup is open
      And I am logged in as 'joe-the-user'
      
  Scenario: User sends an invitation
    When I go to the 'invitations page'
      And I click link '[ invite ]'
      And I fill in 'email' with 'joe-the-friend@xxmailxx.com'
      And I click button 'Send'
    Then the following invitations should exist:
      | inviter      | email                   |
      | joe-the-user | joe-the-friend@mail.com |
      And page should countain text 'An invitation email was sent to joe-the-friend@xxmailxx.com.'
      And page should countain the code for invitation with email 'joe-the-friend@xxmailxx.com'

  Scenario: User cancels an invitation
    Given the following invitations exist:
      | inviter      | email                   | code             |
      | joe-the-user | joe-the-friend@mail.com | BEA53C766E9287EC |
    When I go to the 'invitations page'
      And I click link '[ cancel ]'
    Then page should countain text 'Invitation successfully cancelled.'
      And page should countain text 'No invitations found.'
      And invitation 'BEA53C766E9287EC' should not exist







