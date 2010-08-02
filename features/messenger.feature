
Feature: Messenger
  In order to communicate with other users
  As a registered user
  I want to be able to use the messenger system

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-user     | user |
      | joe-the-sender   | user | 
      | joe-the-receiver | user |      
      And user 'joe-the-user' attribute 'delete_on_reply' is 'false'
      And user 'joe-the-user' attribute 'save_sent' is 'false'      
      And I am logged in as 'joe-the-user'

  Scenario: User sends a message and sent message is saved
    Given user 'joe-the-user' attribute 'save_sent' is 'true'
    When I go to the 'new message page'
      And I fill in 'to' with 'joe-the-receiver'
      And I fill in 'message_subject' with 'n_message_subject'
      And I fill in 'message_body' with 'n_message_body'
      And I click button 'Send'
    Then page should countain text 'Message successfully sent.' 
      And the following messages with body including 'n_message_body' should exist: 
        | sender       | receiver         | subject           | folder | unread |
        | joe-the-user | joe-the-receiver | n_message_subject | inbox  | true   |
        | joe-the-user | joe-the-receiver | n_message_subject | sent   | true   |

  Scenario: User browses a messenger folder
    Given the following messages exist:
      | sender         | receiver     | subject               | body             | folder |
      | joe-the-sender | joe-the-user | message_one_subject   | message_one_body | inbox  |
      | joe-the-sender | joe-the-user | message_two_subject   | message_two_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
    Then page should countain text 'Inbox'
      And page should countain text 'joe-the-sender'
      And page should countain text 'message_one_subject'
      And page should countain text 'message_two_subject'

  Scenario: User browses a messenger folder using pagination links
    Given the following messages exist:
      | sender         | receiver     | subject               | body               | folder |
      | joe-the-sender | joe-the-user | message_one_subject   | message_one_body   | inbox  |
      | joe-the-sender | joe-the-user | message_two_subject   | message_two_body   | inbox  |
      | joe-the-sender | joe-the-user | message_three_subject | message_three_body | inbox  |
      | joe-the-sender | joe-the-user | message_four_subject  | message_four_body  | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I click link '04 - 04'
    Then page should countain text '04 - 04'
      And page should not countain link '04 - 04'
      And page should countain link '01 - 03'

  Scenario: User reads a message
    Given the following messages exist:
      | sender         | receiver     | subject           | body           | folder |
      | joe-the-sender | joe-the-user | n_message_subject | n_message_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I click link 'n_message_subject'
    Then page should countain text 'joe-the-sender'
      And page should countain text 'n_message_subject'
      And page should countain text 'n_message_body'
      And the following messages should exist: 
        | sender         | receiver     | subject           | folder | unread |
        | joe-the-sender | joe-the-user | n_message_subject | inbox  | false  | 

  @allow-rescue
  Scenario: User tries to read another users message
    Given the following messages exist:
      | sender         | receiver         | subject           | body           | folder |
      | joe-the-sender | joe-the-receiver | n_message_subject | n_message_body | inbox  |
    When I go to the 'message details page for message "n_message_subject"'
    Then page should countain text 'Access Denied'

  Scenario: User replies a message
    Given the following messages exist:
      | sender         | receiver     | subject           | body           | folder |
      | joe-the-sender | joe-the-user | n_message_subject | n_message_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I click link 'n_message_subject'
      And I click link '[ reply ]'
      And I click button 'Send'
    Then the following messages with body including 'joe-the-sender wrote:' should exist: 
      | sender       | receiver       | subject               | folder | unread |
      | joe-the-user | joe-the-sender | Re: n_message_subject | inbox  | true   |          
  
  Scenario: A replied message should be sent to folder trash 
    Given user 'joe-the-user' attribute 'delete_on_reply' is 'true'
      And the following messages exist:
        | sender         | receiver     | subject           | body           | folder |
        | joe-the-sender | joe-the-user | n_message_subject | n_message_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I click link 'n_message_subject'
      And I click link '[ reply ]'
      And I click button 'Send'
    Then page should countain text 'Inbox'
      And page should countain text 'folder is empty'
      And the following messages should exist: 
        | sender         | receiver       | subject               | folder | unread |
        | joe-the-sender | joe-the-user   | n_message_subject     | trash  | false  |
        | joe-the-user   | joe-the-sender | Re: n_message_subject | inbox  | true   | 
          
  Scenario: User forwards a message
    Given the following messages exist:
      | sender         | receiver     | subject           | body           | folder |
      | joe-the-sender | joe-the-user | n_message_subject | n_message_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I click link 'n_message_subject'
      And I click link '[ forward ]'
      And I fill in 'to' with 'joe-the-receiver'
      And I click button 'Send'
    Then the following messages with body including 'joe-the-sender wrote:' should exist: 
      | sender       | receiver         | subject                | folder | unread |
      | joe-the-user | joe-the-receiver | Fwd: n_message_subject | inbox  | true   |          

  Scenario: User moves a message when reading it
    Given the following messages exist:
      | sender         | receiver     | subject           | body           | folder |
      | joe-the-sender | joe-the-user | n_message_subject | n_message_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I click link 'n_message_subject'
      And I select 'Trash' from 'destination_folder'
      And I click button 'Move to:'
    Then page should countain text 'Message successfully moved.'
      And page should countain text 'folder is empty'
      And the following messages should exist: 
        | sender         | receiver     | subject           | folder | unread |
        | joe-the-sender | joe-the-user | n_message_subject | trash  | false  | 
        
  Scenario: User moves messages when browsing a folder
    Given the following messages exist:
      | sender         | receiver     | subject               | body               | folder |
      | joe-the-sender | joe-the-user | message_one_subject   | message_one_body   | inbox  |
      | joe-the-sender | joe-the-user | message_two_subject   | message_two_body   | inbox  |
      | joe-the-sender | joe-the-user | message_three_subject | message_three_body | inbox  |
    When I go to the 'messenger page for folder "inbox"'
      And I check message checkbox for message with subject 'message_one_subject'
      And I check message checkbox for message with subject 'message_three_subject'
      And I select 'Trash' from 'destination_folder'
      And I click button 'Move to:'
    Then page should countain text 'Message(s) successfully moved.'
      And page should not countain text 'message_one_subject'
      And page should countain text 'message_two_subject'
      And page should not countain text 'message_three_subject'      
      And the following messages should exist: 
        | sender         | receiver     | subject               | folder | unread |
        | joe-the-sender | joe-the-user | message_one_subject   | trash  | true   |
        | joe-the-sender | joe-the-user | message_three_subject | trash  | true   |
        | joe-the-sender | joe-the-user | message_two_subject   | inbox  | true   |


