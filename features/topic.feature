
Feature: Topic
  In order to discuss ideas in the forums
  As a registered user
  I want to be able to create topics

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And a forum with name 'n_forum_name' exists
      And I am logged in as 'joe-the-user'

  Scenario: User creates a topic in a forum
    When I go to the 'forum details page for forum "n_forum_name"'
      And I click link '[ new topic ]'
      And I fill in 'topic_title' with 'n_topic_title'
      And I fill in 'topic_body' with 'n_topic_body'
      And I click button 'Create'
    Then topic with title 'n_topic_title' should exist with attributes:
      | forum        | creator      | body         |
      | n_forum_name | joe-the-user | n_topic_body | 
      And page should countain text 'Topic successfully created.'
      And page should countain text 'n_topic_title'
      And page should countain text 'n_topic_body'

  Scenario: User edits a topic
    Given the following topics exist:
      | forum        | creator      | title         | body         |
      | n_forum_name | joe-the-user | n_topic_title | n_topic_body | 
    When I go to the 'forum details page for forum "n_forum_name"'
      And I click link 'n_topic_title'
      And I click link 'edit'
      And I fill in 'topic_title' with 'e_topic_title'
      And I fill in 'topic_body' with 'e_topic_body'
      And I click button 'Edit'
    Then topic with title 'e_topic_title' should exist with attributes:
      | forum        | creator      | body         |
      | n_forum_name | joe-the-user | e_topic_body | 
      And page should countain text 'Topic successfully edited.'
      And page should countain text 'e_topic_title'
      And page should countain text 'e_topic_body'      



