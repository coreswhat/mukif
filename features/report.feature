
Feature: Report
  In order to report bad thins
  As a registered user
  I want to be able to file reports for them

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And I am logged in as 'joe-the-user' 

  Scenario: User reports another user  
    Given the following users exist:
      | username         | role |
      | joe-the-bad-user | user |
    When I go to the 'user details page for user "joe-the-bad-user"'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for user 'joe-the-bad-user' with reason 'whatever_reason' should exist

  Scenario: User reports a torrent
    Given the following users exist:
      | username         | role |
      | joe-the-uploader | user |      
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader |  
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for torrent 'joe_the_uploaders_torrent' with reason 'whatever_reason' should exist

  Scenario: User reports a torrent comment
    Given the following users exist:
      | username          | role |
      | joe-the-commenter | user |      
      And the following torrents exist:
        | name                  | uploader     |
        | joe_the_users_torrent | joe-the-user |
      And the following torrent comments exist:
        | torrent               | commenter         | body           |
        | joe_the_users_torrent | joe-the-commenter | n_comment_body |  
    When I go to the 'torrent details page for torrent "joe_the_users_torrent"'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for comment 'n_comment_body' with reason 'whatever_reason' should exist
      
  Scenario: User reports a wish
      Given the following users exist:
      | username       | role | email                   |
      | joe-the-wisher | user | joe-the-wisher@mail.com |      
      And the following wishes exist:
        | name                 | wisher         |
        | joe_the_wishers_wish | joe-the-wisher | 
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for wish 'joe_the_wishers_wish' with reason 'whatever_reason' should exist      

  Scenario: User reports a wish comment
    Given the following users exist:
      | username          | role |
      | joe-the-commenter | user |      
      And the following wishes exist:
        | name               | wisher       |
        | joe_the_users_wish | joe-the-user | 
      And the following wish comments exist:
        | wish               | commenter         | body           |
        | joe_the_users_wish | joe-the-commenter | n_comment_body | 
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for wish comment 'n_comment_body' with reason 'whatever_reason' should exist

  Scenario: User reports a topic
    Given the following users exist:
      | username       | role | email                   |
      | joe-the-poster | user | joe-the-poster@mail.com |      
      And a forum with name 'n_forum_name' exists
      And the following topics exist:
        | forum        | creator        | title         | body         |
        | n_forum_name | joe-the-poster | n_topic_title | n_topic_body |
   When I go to the 'forum details page for forum "n_forum_name"'
      And I click link 'n_topic_title'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for topic 'n_topic_title' with reason 'whatever_reason' should exist

  Scenario: User reports a post
    Given the following users exist:
      | username       | role | email                   |
      | joe-the-poster | user | joe-the-poster@mail.com |      
      And a forum with name 'n_forum_name' exists
      And the following topics exist:
        | forum        | creator      | title         | body       |
        | n_forum_name | joe-the-user | n_topic_title | n_topic_body |
      And the following posts exist:
        | forum        | topic         | creator        | body        |
        | n_forum_name | n_topic_title | joe-the-poster | n_post_body |  
   When I go to the 'forum details page for forum "n_forum_name"'
      And I click link 'n_topic_title'
      And I click link 'report'
      And I fill in 'reason' with 'whatever_reason'
      And I click button 'Send'
    Then page should countain text 'Report Sent'
      And a report for post 'n_post_body' with reason 'whatever_reason' should exist


