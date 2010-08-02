
Feature: Torrent comment
  In order to give my opinion about a torrent
  As a registered user
  I want to be able to add comments to it

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-user     | user |
      | joe-the-uploader | user |
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader | 
      And I am logged in as 'joe-the-user'

  Scenario: User adds a comment to a torrent
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I fill in 'comment_body' with 'n_comment_body'
      And I click button 'Submit'
    Then page should countain text 'Torrent Details'
      And page should countain text 'Comment successfully added.'
      And the following comments for torrent 'joe_the_uploaders_torrent' should exist:
        | commenter    | body           |
        | joe-the-user | n_comment_body |

  Scenario: User edits its own torrent comment
    Given the following torrent comments exist:
      | torrent                   | commenter    | body           |
      | joe_the_uploaders_torrent | joe-the-user | n_comment_body |
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'edit'
      And I fill in 'comment_body' with 'e_comment_body'
      And I click button 'Edit'
    Then page should countain text 'Torrent Details'
      And page should countain text 'Comment successfully edited.'
      And page should countain text 'edited by joe-the-user'
      And the following comments for torrent 'joe_the_uploaders_torrent' should exist:
        | commenter    | body           |
        | joe-the-user | e_comment_body |

