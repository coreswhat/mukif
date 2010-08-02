
Feature: User Edition
  In order to change my profile
  As a registered user
  I want to be able to edit it

  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And a style with description 'e_style' exists
      And a gender with description 'e_gender' exists
      And a country with description 'e_country' exists
      And I am logged in as 'joe-the-user'

  Scenario: User edits its regular profile info
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'joe-the-user'
      And I select 'e_style' from 'user_style_id'
      And I select 'e_gender' from 'user_gender_id'
      And I select 'e_country' from 'user_country_id'      
      And I fill in 'user_avatar' with 'e_avatar'
      And I fill in 'user_info' with 'e_info'
      And I fill in 'user_email' with 'e@mail.com'
      And I click button 'Edit'
    Then page should countain text 'Profile successfully edited.'
      And the following users should exist:
        | username     | email      | style   | gender   | country   | avatar   | info   |        
        | joe-the-user | e@mail.com | e_style | e_gender | e_country | e_avatar | e_info |

  @allow-rescue
  Scenario: Non admin user tries to edit other users profile info
    Given the following users exist:
      | username         | role |
      | joe-the-user-two | user |
    When I go to the 'user edition page for user "joe-the-user-two"'
    Then page should countain text 'Access Denied'

  Scenario: User edits its password
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'joe-the-user'
      And I fill in 'user_password' with 'e_password'
      And I fill in 'user_password_confirmation' with 'e_password'
      And I click button 'Edit'
      And I click link 'Logout'
      And I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'e_password'
      And I click button 'Login'
    Then page should countain text 'joe-the-user'
      And page should countain text 'Logout'
      
  Scenario: User tries to edit its password with incorrect confirmation
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'joe-the-user'
      And I fill in 'user_password' with 'e_password'
      And I fill in 'user_password_confirmation' with 'nononono'
      And I click button 'Edit'
    Then page should countain text 'Profile Edition'
      And page should countain text 'Incorrect password confirmation.'            
      
  Scenario: User edits its privacy settings
    Given user 'joe-the-user' attribute 'display_last_request_at' is 'true'
      And user 'joe-the-user' attribute 'display_uploads' is 'false'
      And user 'joe-the-user' attribute 'display_snatches' is 'true'
      And user 'joe-the-user' attribute 'display_seeding' is 'false'
      And user 'joe-the-user' attribute 'display_leeching' is 'true'
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'joe-the-user'
      And I uncheck 'user_display_last_request_at'
      And I check 'user_display_uploads'
      And I uncheck 'user_display_snatches'
      And I check 'user_display_seeding'
      And I uncheck 'user_display_leeching'
      And I click button 'Edit'
    Then page should countain text 'Profile successfully edited.'
      And privacy settings for user 'joe-the-user' should be:
        | show last seen | show uploads | show snatches | show seeding | show leeching |        
        | false          | true         | false         | true         | false         |
        
  Scenario: User edits its messenger settings
    Given user 'joe-the-user' attribute 'save_sent' is 'true'
      And user 'joe-the-user' attribute 'delete_on_reply' is 'false'
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'joe-the-user'
      And I uncheck 'user_save_sent'
      And I check 'user_delete_on_reply'
      And I click button 'Edit'
    Then page should countain text 'Profile successfully edited.'
      And messenger settings for user 'joe-the-user' should be:
        | save sent | delete on reply |         
        | false     | true            |        

  Scenario: User edits its default search types
    Given user 'joe-the-user' attribute 'default_types' is ''
      And a type with description 'n_type_one' exists
      And a type with description 'n_type_two' exists
      And a type with description 'n_type_three' exists    
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'joe-the-user'
      And I check default type checkbox for type 'n_type_one'
      And I check default type checkbox for type 'n_type_three'
      And I click button 'Edit'
    Then page should countain text 'Profile successfully edited.'
      And default types for user 'joe-the-user' should include 'n_type_one'
      And default types for user 'joe-the-user' should not include 'n_type_two'
      And default types for user 'joe-the-user' should include 'n_type_three'

  Scenario: User tries to edit its profile without current password
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with ''
      And I select 'e_style' from 'user_style_id'
      And I click button 'Edit'
    Then page should countain text 'Profile Edition'
      And page should countain text 'Current password required.'     

  Scenario: User tries to edit its profile with incorrect current password
    When I click user box link 'joe-the-user'
      And I click link 'edit profile'
      And I fill in 'current_password' with 'nononono'
      And I select 'e_style' from 'user_style_id'
      And I click button 'Edit'
    Then page should countain text 'Profile Edition'
      And page should countain text 'Current password incorrect.'     

