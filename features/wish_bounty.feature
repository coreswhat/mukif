
Feature: Wish Bounty
  In order to reward wish fillers
  As a registered user
  I want to be able to add bounties to wishes

  Background:
    Given the following users exist:
      | username           | role |
      | joe-the-user       | user |
      | joe-the-uploader   | user |
      | joe-the-wisher     | user |
      | joe-the-filler     | user |
      | joe-the-mod        | mod  |
      And I am logged in as 'joe-the-user'

  Scenario: User adds a bounty to a wish
    Given user 'joe-the-user' attribute 'uploaded' is '10485760'
      And the following wishes exist:
        | name               | wisher       |
        | joe_the_users_wish | joe-the-user |
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I click link 'bounties'
      And I click link '[ add bounty ]'
      And I fill in 'bounty_amount' with '10'
      And I select 'MB' from 'bounty_unit'
      And I click button 'Confirm'
    Then page should countain text 'Request bounty successfully added.'
      And page should countain text '10.00 MB'
      And the following wish bonties should exist:
        | wish               | bounter      | amount   | revoked |
        | joe_the_users_wish | joe-the-user | 10485760 | false   |
      And user 'joe-the-user' attribute 'uploaded' should be '0'
      And wish 'joe_the_users_wish' attribute 'total_bounty' should be '10485760'      

  Scenario: User tries to add a bounty to a wish having insufficient upload credit
    Given user 'joe-the-user' attribute 'uploaded' is '0'
      And the following wishes exist:
        | name               | wisher       |
        | joe_the_users_wish | joe-the-user |
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I click link 'bounties'
      And I click link '[ add bounty ]'
      And I fill in 'bounty_amount' with '10'
      And I select 'MB' from 'bounty_unit'
      And I click button 'Confirm'
    Then page should countain text 'Your upload credit is insufficient.'
    
  Scenario: User revokes a wish bounty  
    Given user 'joe-the-user' attribute 'uploaded' is '10485760'
      And the following wishes exist:
        | name               | wisher       |
        | joe_the_users_wish | joe-the-user |
      And the following wish bounties exist:
        | wish               | bounter      | amount   | revoked |
        | joe_the_users_wish | joe-the-user | 10485760 | false   |     
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I click link 'bounties'
      And I click link '[ revoke ]'
      And I click button 'Revoke'
    Then page should countain text 'Request bounty successfully revoked.'
      And the following wish bonties should exist:
        | wish               | bounter      | amount   | revoked |
        | joe_the_users_wish | joe-the-user | 10485760 | true    |
      And user 'joe-the-user' attribute 'uploaded' should be '10485760'
      And wish 'joe_the_users_wish' attribute 'total_bounty' should be '0'
    







