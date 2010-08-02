
Feature: Wish Filling
  In order to make wishers happy and eventually collect a reward
  As a registered user
  I want to be able to fill wishes

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-user     | user |
      | joe-the-uploader | user |
      | joe-the-wisher   | user |
      | joe-the-filler   | user |
      | joe-the-mod      | mod  |
      And I am logged in as 'joe-the-user'

  Scenario: User fills a wish
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
      And the following torrents exist:
        | name                  | uploader     |
        | joe_the_users_torrent | joe-the-user |   
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'fill this request'
      And I paste torrent 'joe_the_users_torrent' info hash hex in info_hash
      And I click button 'Confirm'
    Then page should countain text 'Request successfully filled.'
      And wish 'joe_the_wishers_wish' should have filling attributes:
        | status  | filler       | torrent               | approver |        
        | Pending | joe-the-user | joe_the_users_torrent |          |        
      And a report for wish 'joe_the_wishers_wish' with reason 'pending' should exist

  @allow-rescue
  Scenario: User tries to fill its own wish
    Given the following wishes exist:
      | name               | wisher       |
      | joe_the_users_wish | joe-the-user |
    When I go to the 'wish filling page for wish "joe_the_users_wish"'
    Then page should countain text 'Access Denied'

  @allow-rescue
  Scenario: User tries to fill a wish that is already filled but pending moderation
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
      And the following torrents exist:
        | name                    | uploader       |
        | joe_the_fillers_torrent | joe-the-filler |   
      And wish 'joe_the_wishers_wish' was filled with torrent 'joe_the_fillers_torrent'
    When I go to the 'wish filling page for wish "joe_the_wishers_wish"'
    Then page should countain text 'Access Denied'

  @allow-rescue
  Scenario: User tries to fill a wish that is already filled and approved by moderation
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
      And the following torrents exist:
        | name                    | uploader     |
        | joe_the_fillers_torrent | joe-the-filler |   
      And wish 'joe_the_wishers_wish' was filled with torrent 'joe_the_fillers_torrent'
      And wish 'joe_the_wishers_wish' had filling approved by 'joe-the-mod'
    When I go to the 'wish filling page for wish "joe_the_wishers_wish"'
    Then page should countain text 'Access Denied'

  Scenario: User tries to fill a wish with an invalid torrent info hash
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'fill this request'
      And I fill in 'info_hash' with 'nonononononono'
      And I click button 'Confirm'
    Then page should countain text 'Invalid torrent info hash.'

  Scenario: User tries to fill a wish with another users torrent
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader |   
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'fill this request'
      And I paste torrent 'joe_the_uploaders_torrent' info hash hex in info_hash
      And I click button 'Confirm'
    Then page should countain text 'Only the torrent uploader can use it to fill a request.'

  Scenario: User tries to fill two wishes with the same torrent
    Given the following wishes exist:
      | name                     | wisher         |
      | joe_the_wishers_wish     | joe-the-wisher |
      | joe_the_wishers_wish_two | joe-the-wisher |
      And the following torrents exist:
        | name                  | uploader     |
        | joe_the_users_torrent | joe-the-user |   
      And wish 'joe_the_wishers_wish' was filled with torrent 'joe_the_users_torrent'
      And wish 'joe_the_wishers_wish' had filling approved by 'joe-the-mod'
    When I go to the 'wish details page for wish "joe_the_wishers_wish_two"'
      And I click link 'fill this request'
      And I paste torrent 'joe_the_users_torrent' info hash hex in info_hash
      And I click button 'Confirm'
    Then page should countain text 'Torrent already used to fill another request.'





