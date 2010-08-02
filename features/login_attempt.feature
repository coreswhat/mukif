
Feature: Login Attempt
  In order to protect the system against brute force login attacks
  As a system developer
  I want to be able ask the application to block an IP after the login attempts limit is exceeded

  # Note: check app config file for login attempts configurations 

  Background:
    Given the following users exist:
      | username     | role |
      | joe-the-user | user | 
      And I am on the 'login page'

  Scenario: Login attempt is created
    When I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'nononono'
      And I click button 'Login'
    Then the following login attempts should exist:
      | ip        | count | blocked |
      | 127.0.0.1 | 1     | false   |

  Scenario: Login attempt is incremented
    Given the following login attempts exist:
      | ip        | count |
      | 127.0.0.1 | 1     |
    When I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'nononono'
      And I click button 'Login'
    Then page should countain text 'username'
      And page should countain text 'password'
      And page should countain text 'Invalid login data. Remaining attempts: 3'
      And the following login attempts should exist:
        | ip        | count | blocked |
        | 127.0.0.1 | 2     | false   |

  Scenario: Login attempts limit surpassed
    Given the following login attempts exist:
      | ip        | count |
      | 127.0.0.1 | 4     |
      And I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'nononono'
      And I click button 'Login'
    Then page should countain text 'username'
      And page should countain text 'password'
      And page should countain text 'Login will remain blocked for 4 hours. Try to recover your password.'
      And the following login attempts should exist:
        | ip        | count | blocked |
        | 127.0.0.1 | 0     | true    |

  Scenario: Login attempt is cleared after successful login
    Given the following login attempts exist:
      | ip        | count |
      | 127.0.0.1 | 1     |
    When I fill in 'username' with 'joe-the-user'
      And I fill in 'password' with 'joe-the-user'
      And I click button 'Login'
    Then page should countain text 'joe-the-user'
      And page should countain text 'Logout'
      And a login attempt for IP '127.0.0.1' should not exist



