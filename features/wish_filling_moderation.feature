
Feature: Wish Filling Moderation
  In order to moderate wish fillings
  As a moderator
  I want to be able to approve or reject them

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-uploader | user |
      | joe-the-wisher   | user |
      | joe-the-filler   | user |
      | joe-the-bounter  | user |
      | joe-the-mod      | mod  |
      And I am logged in as 'joe-the-mod'

  Scenario: A wish filling is rejected
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
      And the following torrents exist:
        | name                  | uploader     |
        | joe_the_fillers_torrent | joe-the-filler |
      And wish 'joe_the_wishers_wish' was filled with torrent 'joe_the_fillers_torrent'
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'reject'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'confirm'
    Then page should countain text 'request filling successfully rejected'
      And wish 'joe_the_wishers_wish' should have filling attributes:
        | status  | filler | torrent | approver |        
        | Open    |        |         |          |  
      And the following messages should exist: 
        | sender | receiver       | subject                  | folder | unread |
        | system | joe-the-filler | request filling rejected | inbox  | true   |
        
  Scenario: A wish filling with bounty transfer is approved
    Given user 'joe-the-filler' attribute 'uploaded' is '0'
      And user 'joe-the-bounter' attribute 'uploaded' is '10485760'        
      And the following wishes exist:
        | name                 | wisher         |
        | joe_the_wishers_wish | joe-the-wisher |         
      And the following torrents exist:
        | name                    | uploader       |
        | joe_the_fillers_torrent | joe-the-filler |
      And the following wish bounties exist:
        | wish                 | bounter         | amount   | revoked |
        | joe_the_wishers_wish | joe-the-bounter | 10485760 | false   |     
      And wish 'joe_the_wishers_wish' was filled with torrent 'joe_the_fillers_torrent'
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'approve'
    Then page should countain text 'request filling successfully approved'
      And wish 'joe_the_wishers_wish' should have filling attributes:
        | status | filler         | torrent                 | approver    |        
        | Filled | joe-the-filler | joe_the_fillers_torrent | joe-the-mod | 
      And user 'joe-the-filler' attribute 'uploaded' should be '10485760'
      And the following messages should exist: 
        | sender | receiver        | subject                      | folder | unread |
        | system | joe-the-bounter | request filled               | inbox  | true   |               
        | system | joe-the-filler  | request filling approved     | inbox  | true   |
        | system | joe-the-wisher  | your request has been filled | inbox  | true   |
        



