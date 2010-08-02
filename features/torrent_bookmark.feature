
Feature: Torrent Bookmark
  In order to remember my favorite torrents
  As a registered user
  I want to be able to bookmark them

  Background:    
    Given the following users exist:
      | username     | role | email                 |
      | joe-the-user | user | joe-the-user@mail.com |
      And the following torrents exist:
        | name                  | uploader     |
        | joe_the_users_torrent | joe-the-user |       
      And I am logged in as 'joe-the-user'
      
  Scenario: User bookmarks a torrent
    When I go to the 'torrent details page for torrent "joe_the_users_torrent"'
      And I click link 'bookmark'
    Then page should countain link 'unbookmark'
      And bookmark for torrent 'joe_the_users_torrent' and user 'joe-the-user' should exist
    
  Scenario: User unbookmarks a torrent
    Given the following bookmarks exist:
      | torrent               | user         |
      | joe_the_users_torrent | joe-the-user |    
    When I go to the 'torrent details page for torrent "joe_the_users_torrent"'
      And I click link 'unbookmark'
    Then page should countain link 'bookmark'
      And bookmark for torrent 'joe_the_users_torrent' and user 'joe-the-user' should not exist
    
    
