
Feature: Torrent Reseed Request
  In order to have seeds in a dead torrent
  As a registered user
  I want to be able to request a reseed
  
  # Note: check app config file for reseed request cost
  
  Background:
    Given the following users exist:
      | username          | role |
      | joe-the-user      | user |      
      | joe-the-uploader  | user |
      | joe-the-samaritan | user |
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader | 
      And torrent 'joe_the_uploaders_torrent' attribute 'seeders_count' is '0' 
      And torrent 'joe_the_uploaders_torrent' attribute 'leechers_count' is '0'
      And torrent 'joe_the_uploaders_torrent' attribute 'snatches_count' is '1'
      And a snatch for torrent 'joe_the_uploaders_torrent' and user 'joe-the-samaritan' exists
      And I am logged in as 'joe-the-user'

  Scenario: User request a reseed
    Given user 'joe-the-user' attribute 'uploaded' is '10485760'
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'reseed request'
      And I click button 'Confirm'
    Then page should countain text 'Torrent Details'
      And page should countain text 'Reseed requests successfully sent.'
      And user 'joe-the-user' attribute 'uploaded' should be '0'
      And the following messages should exist: 
        | sender | receiver          | subject          | folder | unread |
        | system | joe-the-uploader  | reseed requested | inbox  | true   |
        | system | joe-the-samaritan | reseed requested | inbox  | true   |     
      
  Scenario: User tries request a reseed having insufficient upload credit
    Given user 'joe-the-user' attribute 'uploaded' is '0'
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'reseed request'
      And I click button 'Confirm'
    Then page should countain text 'Your upload credit is insufficient.'      


