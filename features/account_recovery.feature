
Feature: Account Recovery
  In order to use the system after forgetting my password
  As a registered user
  I want to be able to recover it

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user | 
      And user 'joe-the-user' attribute 'email' is 'joe-the-user@xxmailxx.com'
      
  Scenario: User requests a recovery code
    When I go to the 'account recovery page'
      And I fill in 'email' with 'joe-the-user@xxmailxx.com'
      And I click button 'Confirm'
    Then an account recovery for user 'joe-the-user' should exist
      And page should countain text 'A password recovery link has been sent to joe-the-user@xxmailxx.com.'
      And page should countain text 'username'
      And page should countain text 'password'

  Scenario: User uses the account recovery code to reset its password
    Given the following account recoveries exist:
      | user         | code            |
      | joe-the-user | WRT5HJ7K8N287EC |
      And the following login attempts exist:
        | ip         | count |
        | 127.0.0.1  | 1     |
    When I go to the 'password reset page with recovery code "WRT5HJ7K8N287EC"'
      And I fill in 'password' with 'n_password'
      And I fill in 'password_confirmation' with 'n_password'
      And I click button 'Confirm'
    Then page should countain text 'Please login'
    When I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'n_password'
      And I click button 'Login'
    Then page should countain text 'joe-the-user'
      And page should countain text 'Logout'
      And a login attempt for IP '127.0.0.1' should not exist
