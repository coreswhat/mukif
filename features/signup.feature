
Feature: Signup
  In order to use the system
  As an unregistered user
  I want to be able to create an account

  Background:
    Given the following users exist:
      | username        | role |
      | joe-the-inviter | user |
      And user 'joe-the-inviter' attribute 'extra_tickets' is 'inviter'
      And a role with name 'user' exists
      And a style with description 'default' exists
      
  Scenario: User creates an account without the need of an invitation code
    Given that signup is open
      And that signup does not require invitation
    When I go to the 'signup page without invitation code'
      And I fill in 'user_username' with 'joe-the-new-user'
      And I fill in 'user_password' with 'joe-the-new-user-password'
      And I fill in 'user_password_confirmation' with 'joe-the-new-user-password'
      And I fill in 'user_email' with 'joe-the-new-user@mail.com'
      And I click button 'Sign Up'
    Then user 'joe-the-new-user' should exist with attributes:
      | email                     | inviter |
      | joe-the-new-user@mail.com |         |      
      And page should countain text 'joe-the-new-user'
      And page should countain text 'Logout'
            
  Scenario: User creates an account with an invitation code although it is not required
    Given that signup is open
      And that signup does not require invitation
      And the following invitations exist:
        | inviter         | email                   | code             |
        | joe-the-inviter | joe-the-friend@mail.com | BEA53C766E9287EC |      
    When I go to the 'signup page with invitation code "BEA53C766E9287EC"'
      And I fill in 'user_username' with 'joe-the-friend'
      And I fill in 'user_password' with 'joe-the-friend-password'
      And I fill in 'user_password_confirmation' with 'joe-the-friend-password'
      And I click button 'Sign Up'
    Then user 'joe-the-friend' should exist with attributes:
      | email                   | inviter         |
      | joe-the-friend@mail.com | joe-the-inviter |       
      And invitation 'BEA53C766E9287EC' should not exist
      And page should countain text 'joe-the-friend'
      And page should countain text 'Logout'      
      
  Scenario: User creates an account with an invalid invitation code when it is not required
    Given that signup is open
      And that signup does not require invitation
    When I go to the 'signup page with invitation code "BEA53C766E9287EC"'
      And I fill in 'user_username' with 'joe-the-new-user'
      And I fill in 'user_password' with 'joe-the-new-user-password'
      And I fill in 'user_password_confirmation' with 'joe-the-new-user-password'
      And I fill in 'user_email' with 'joe-the-new-user@mail.com'
      And I click button 'Sign Up'
    Then user 'joe-the-new-user' should exist with attributes:
      | email                     | inviter |
      | joe-the-new-user@mail.com |         |
      And page should countain text 'joe-the-new-user'
      And page should countain text 'Logout'

  Scenario: User creates an account having to provide an invitation code
    Given that signup is open
      And that signup requires invitation
      And the following invitations exist:
        | inviter         | email                   | code             |
        | joe-the-inviter | joe-the-friend@mail.com | BEA53C766E9287EC |
    When I go to the 'signup page with invitation code "BEA53C766E9287EC"'
      And I fill in 'user_username' with 'joe-the-friend'
      And I fill in 'user_password' with 'joe-the-friend-password'
      And I fill in 'user_password_confirmation' with 'joe-the-friend-password'
      And I click button 'Sign Up'
    Then user 'joe-the-friend' should exist with attributes:
      | email                   | inviter         |
      | joe-the-friend@mail.com | joe-the-inviter |      
      And invitation 'BEA53C766E9287EC' should not exist
      And page should countain text 'joe-the-friend'
      And page should countain text 'Logout'

  Scenario: User tries to sign up without an invitation code when it is required
    Given that signup is open
      And that signup requires invitation
    When I go to the 'signup page without invitation code'
      And I fill in 'user_username' with 'joe-the-friend'
      And I fill in 'user_password' with 'joe-the-friend-password'
      And I fill in 'user_password_confirmation' with 'joe-the-friend-password'
      And I click button 'Sign Up'
    Then page should countain text 'Invitation code required.'
    
  Scenario: User tries to use an invalid invitation code when it is required
    Given that signup is open
      And that signup requires invitation
    When I go to the 'signup page without invitation code'
      And I fill in 'user_username' with 'joe-the-friend'
      And I fill in 'user_password' with 'joe-the-friend-password'
      And I fill in 'user_password_confirmation' with 'joe-the-friend-password'
      And I fill in 'invitation_code' with 'nonononono'
      And I click button 'Sign Up'
    Then page should countain text 'Invitation code invalid.'
      
  Scenario: User tries to signup when signup is closed
    Given that signup is closed
    When I go to the 'signup page without invitation code'
    Then page should countain text 'Signup is currently closed.'
      And page should countain text 'Please login'

  Scenario: User tries to signup with invitation code when signup is closed
    Given that signup is closed
      And the following invitations exist:
        | inviter         | email                   | code             |
        | joe-the-inviter | joe-the-friend@mail.com | BEA53C766E9287EC |
    When I go to the 'signup page with invitation code "BEA53C766E9287EC"'
    Then page should countain text 'Signup is currently closed.'
      And page should countain text 'Please login'

