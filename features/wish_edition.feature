
Feature: Wish Edition
  In order to change a wishes information
  As a registered user
  I want to be able to edit them

  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And the following wishes exist:
        | name               | wisher       |
        | joe_the_users_wish | joe-the-user |       
      And a type with description 'e_type' exists
      And a format with description 'e_format' exists
      And I am logged in as 'joe-the-user'

  Scenario: User updates its own wish
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I click link 'edit'
      And I select 'e_type' from 'wish_type_id'
      And I fill in 'wish_name' with 'e_name'
      And I select 'e_format' from 'wish_format_id'
      And I fill in 'wish_description' with 'e_description'
      And I click button 'Edit'
    Then page should countain text 'Request successfully edited.'
      And the following wishes should exist:
        | type   | name   | format   | wisher       | description   |        
        | e_type | e_name | e_format | joe-the-user | e_description |



