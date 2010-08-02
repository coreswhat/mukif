
Feature: Wish comment
  In order to give my opinion about a wish
  As a registered user
  I want to be able to add comments to it

  Background:
    Given the following users exist:
      | username           | role |
      | joe-the-user       | user |
      | joe-the-wisher     | user |
      And I am logged in as 'joe-the-user'

  Scenario: User adds a comment to a wish      
    Given the following wishes exist:
      | name               | wisher       |
      | joe_the_users_wish | joe-the-user |
    When I go to the 'wish details page for wish "joe_the_users_wish"'
      And I fill in 'wish_comment_body' with 'n_comment_body'
      And I click button 'Submit'
    Then page should countain text 'Request Details'
      And page should countain text 'Comment successfully added.'
      And the following comments for wish 'joe_the_users_wish' should exist:
        | commenter    | body           |
        | joe-the-user | n_comment_body |

  Scenario: User edits its own wish comment
    Given the following wishes exist:
      | name                 | wisher         |
      | joe_the_wishers_wish | joe-the-wisher |
      And the following wish comments exist:
        | wish                 | commenter    | body           |
        | joe_the_wishers_wish | joe-the-user | n_comment_body |
    When I go to the 'wish details page for wish "joe_the_wishers_wish"'
      And I click link 'edit'
      And I fill in 'wish_comment_body' with 'e_comment_body'
      And I click button 'Edit'
    Then page should countain text 'Request Details'
      And page should countain text 'Comment successfully edited.'
      And page should countain text 'e_comment_body'
      And the following comments for wish 'joe_the_wishers_wish' should exist:
        | commenter    | body           |
        | joe-the-user | e_comment_body |


