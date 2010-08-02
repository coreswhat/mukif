
Feature: Torrent Browsing
  In order to se existing torrents
  As a registered user
  I want to be able to browse them
  
  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And I am logged in as 'joe-the-user'

  Scenario: User browses torrents using pagination links
    Given the following torrents exist:
        | name                        | uploader     |
        | joe_the_users_torrent       | joe-the-user |
        | joe_the_users_torrent_two   | joe-the-user |
        | joe_the_users_torrent_three | joe-the-user | 
    When I go to the 'torrents page'
      And I click link '03 - 03'
    Then page should countain text '03 - 03'
      And page should not countain link '03 - 03'
      And page should countain link '01 - 02'
      
