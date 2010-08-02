
Feature: Post
  In order to discuss ideas in the forums
  As a registered user
  I want to be able to publish posts

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-user     | user |
      | joe-the-user-two | user |
      And a forum with name 'n_forum_name' exists
      And I am logged in as 'joe-the-user'

  Scenario: User creates a post in a topic
    Given the following topics exist:
      | forum        | creator      | title         | body         |
      | n_forum_name | joe-the-user | n_topic_title | n_topic_body |
    When I go to the 'forum details page for forum "n_forum_name"'
      And I click link 'n_topic_title'
      And I fill in 'post_body' with 'n_post_body'
      And I click button 'Submit'
    Then post with body 'n_post_body' should exist with attributes:
      | forum         | topic         | creator      |
      | n_forum_name  | n_topic_title | joe-the-user | 
      And page should countain text 'Post successfully added.'
      And page should countain text 'n_post_body'
      
  Scenario: User edits a post
    Given the following topics exist:
      | forum        | creator          | title         | topic post body |
      | n_forum_name | joe-the-user-two | n_topic_title | n_topic_body    | 
      And the following posts exist:
        | forum        | topic         | creator      | body        |
        | n_forum_name | n_topic_title | joe-the-user | n_post_body |
    When I go to the 'forum details page for forum "n_forum_name"'
      And I click link 'n_topic_title'
      And I click link 'edit'
      And I fill in 'post_body' with 'e_post_body'
      And I click button 'Edit'
    Then post with body 'e_post_body' should exist with attributes:
      | forum        | topic         | creator      |
      | n_forum_name | n_topic_title | joe-the-user | 
      And page should countain text 'Post successfully edited.'
      And page should countain text 'e_post_body'


