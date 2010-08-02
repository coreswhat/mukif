
Feature: User Profile
  In order to check users profiles
  As a registered user
  I want to be able to visualize them

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-user     | user |
      | joe-the-user-two | user |
      | joe-the-mod      | mod  |
      And role 'mod' attribute 'tickets' is 'staff' 

  Scenario: User visualizes its own profile
    Given I am logged in as 'joe-the-user'
      And user 'joe-the-user' attribute 'email' is 'joe-the-user@mail.com' 
      And user 'joe-the-user' attribute 'passkey' is 'joe_the_user_passkey'
    When I go to the 'user details page for user "joe-the-user"'
    Then page should countain text 'User Details'
      And page should not countain link 'staff info'
      And page should countain link 'edit profile'
      And page should countain link 'reset passkey'
      And page should countain text 'joe-the-user@mail.com'
      And page should countain text 'joe_ ... skey'
      And page should countain text 'Last seen'
      And page should countain text 'Uploads'
      And page should countain text 'Snatches'
      And page should countain text 'Seeding'
      And page should countain text 'Leeching'

  Scenario: User visualizes another users profile
    Given I am logged in as 'joe-the-user'
      And user 'joe-the-user-two' attribute 'email' is 'joe-the-user-two@mail.com' 
      And user 'joe-the-user-two' attribute 'passkey' is 'joe_the_user_two_passkey'
      And user 'joe-the-user-two' attribute 'display_last_request_at' is 'false'
      And user 'joe-the-user-two' attribute 'display_uploads' is 'false'
      And user 'joe-the-user-two' attribute 'display_snatches' is 'false'
      And user 'joe-the-user-two' attribute 'display_seeding' is 'false'
      And user 'joe-the-user-two' attribute 'display_leeching' is 'false'
    When I go to the 'user details page for user "joe-the-user-two"'
    Then page should countain text 'User Details'
      And page should not countain link 'staff info'
      And page should not countain link 'edit profile'
      And page should not countain link 'reset passkey'
      And page should not countain text 'joe-the-user-two@mail.com'
      And page should not countain text 'joe_ ... skey'
      And page should not countain text 'Last seen'
      And page should not countain text 'Uploads'
      And page should not countain text 'Snatches'
      And page should not countain text 'Seeding'
      And page should not countain text 'Leeching'
      
  Scenario: Moderator visualizes another users profile
    Given I am logged in as 'joe-the-mod'
      And user 'joe-the-user-two' attribute 'email' is 'joe-the-user-two@mail.com' 
      And user 'joe-the-user-two' attribute 'passkey' is 'joe_the_user_two_passkey'
      And user 'joe-the-user-two' attribute 'display_last_request_at' is 'false'
      And user 'joe-the-user-two' attribute 'display_uploads' is 'false'
      And user 'joe-the-user-two' attribute 'display_snatches' is 'false'
      And user 'joe-the-user-two' attribute 'display_seeding' is 'false'
      And user 'joe-the-user-two' attribute 'display_leeching' is 'false'
    When I go to the 'user details page for user "joe-the-user-two"'
    Then page should countain text 'User Details'
      And page should countain link 'staff info'
      And page should not countain link 'edit profile'
      And page should not countain link 'reset passkey'
      And page should not countain text 'joe-the-user-two@mail.com'
      And page should not countain text 'joe_ ... skey'
      And page should not countain text 'Last seen'
      And page should not countain text 'Uploads'
      And page should not countain text 'Snatches'
      And page should not countain text 'Seeding'
      And page should not countain text 'Leeching'
      

