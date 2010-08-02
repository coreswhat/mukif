
Feature: User Passke Reset
  In order to keep my passkey safe
  As a registered user
  I want to be able to reset it

  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And I am logged in as 'joe-the-user'

  Scenario: User resets its own passkey
    Given user 'joe-the-user' attribute 'passkey' is 'USER_PASSKEY'
    When I click user box link 'joe-the-user'
      And I click link 'reset passkey'
      And I click button 'Confirm'
    Then page should countain text 'Passkey successfully reset.'
      And user 'joe-the-user' attribute 'passkey' should not be 'USER_PASSKEY'
