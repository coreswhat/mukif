
Feature: Torrent deletion
  In order to delete torrents from the site
  As a moderator
  I want to be able to completely delete them

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-uploader | user |
      | joe-the-mod      | mod  |
      And I am logged in as 'joe-the-mod'
      
  Scenario: Moderator deletes another users torrent
    Given the following torrents exist:
      | name                      | uploader         |
      | joe_the_uploaders_torrent | joe-the-uploader | 
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'delete'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'delete'
    Then page should countain text 'torrent successfully deleted'
      And torrent 'joe_the_uploaders_torrent' should not exist
      And the following messages should exist: 
        | sender | receiver         | subject         | folder | unread |
        | system | joe-the-uploader | torrent deleted | inbox  | true   |
