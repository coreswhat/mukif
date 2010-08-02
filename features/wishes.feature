
Feature: Wishes
  In order to request inexistent torrents
  As a registered user
  I want to be able to create wishes
  
  # Note: in the user interface, wishes are referred as requests

  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And a type with description 'n_type' exists
      And a format with description 'n_format' exists
      And I am logged in as 'joe-the-user'

  Scenario: User creates a wish
    Given user 'joe-the-user' attribute 'extra_tickets' is 'wisher'
    When I go to the 'new wish page'
      And I select 'n_type' from 'wish_type_id'
      And I fill in 'wish_name' with 'joe_the_users_wish'
      And I select 'n_format' from 'wish_format_id'
      And I fill in 'wish_description' with 'n_description'
      And I click button 'Create'
    Then page should countain text 'Request successfully created.'
      And wish 'joe_the_users_wish' should exist with attributes:
        | type   | format   | wisher       | description   |        
        | n_type | n_format | joe-the-user | n_description |
  
  @allow-rescue      
  Scenario: User tries to create a wish without authorization ticket
    Given user 'joe-the-user' attribute 'extra_tickets' is 'nonono'
    When I go to the 'new wish page'
    Then page should countain text 'Access Denied'
