
Feature: Torrent Inactivation
  In order to inactivate torrents
  As a registered user or a moderator
  I want to be able to inactivate them

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-uploader | user |
      | joe-the-mod      | mod  |

  Scenario: User inactivates its own torrent
    Given I am logged in as 'joe-the-uploader'
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader | 
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'remove'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Remove'
    Then page should countain text 'Your torrent will stay inactive until a moderator removes it.'
      And torrent 'joe_the_uploaders_torrent' attribute 'active' should be 'false'
      And a report for torrent 'joe_the_uploaders_torrent' with reason 'inactivated' should exist

  Scenario: Moderator inactivates another users torrent
    Given I am logged in as 'joe-the-mod'
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader | 
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'remove'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Remove'
    Then page should countain text 'torrent successfully inactivated'
      And page should countain link 'activate'
      And torrent 'joe_the_uploaders_torrent' attribute 'active' should be 'false'
      And the following messages should exist: 
        | sender | receiver         | subject             | folder | unread |
        | system | joe-the-uploader | torrent inactivated | inbox  | true   |
