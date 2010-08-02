
Feature: Torrent Download
  In order to download content
  As a registered user
  I want to be able to download torrent files

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And I am logged in as 'joe-the-user'
      And I uploaded torrent file 'valid.torrent' as 'joe_the_users_torrent'

  @rack_test_driver
  Scenario: User downloads a torrent file    
    When I go to the 'torrent details page for torrent "joe_the_users_torrent"'
      And I click link 'joe_the_users_torrent.torrent'
    Then downloaded torrent should have same info hash as torrent 'joe_the_users_torrent'
    
  Scenario: User tries to downloads a torrent file for an inactive torrent
    Given I am on the 'torrent details page for torrent "joe_the_users_torrent"'
      And torrent 'joe_the_users_torrent' is inactivated    
    When I click link 'joe_the_users_torrent.torrent'
    Then page should countain text 'The requested torrent does not exist or is currently unavailable.'

  Scenario: User tries to downloads a torrent file for an inexistent torrent
    Given I am on the 'torrent details page for torrent "joe_the_users_torrent"'
      And torrent 'joe_the_users_torrent' is deleted
      And I click link 'joe_the_users_torrent.torrent'
    Then page should countain text 'The requested torrent does not exist or is currently unavailable.'
