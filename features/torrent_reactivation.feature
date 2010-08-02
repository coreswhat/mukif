
Feature: Torrent Reactivation
  In order to reactivate inactive torrents
  As a moderator
  I want to be able to do so

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-uploader | user |
      | joe-the-mod      | mod  |
      And I am logged in as 'joe-the-mod'

  Scenario: Moderator reactivates an inactive torrent
    Given the following torrents exist:
      | name                      | uploader         |
      | joe_the_uploaders_torrent | joe-the-uploader | 
      And torrent 'joe_the_uploaders_torrent' is inactivated
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'activate'
    Then page should countain text 'torrent successfully activated'
      And page should countain link 'remove'
      And torrent 'joe_the_uploaders_torrent' attribute 'active' should be 'true'
      And the following messages should exist: 
        | sender | receiver         | subject           | folder | unread |
        | system | joe-the-uploader | torrent activated | inbox  | true   |
