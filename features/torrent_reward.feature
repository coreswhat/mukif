
Feature: Torrent reward
  In order to reward torrent creators
  As a registered user
  I want to be able to add rewards to torrents

  Background:
    Given the following users exist:
      | username         | role |
      | joe-the-user     | user |
      | joe-the-uploader | user |
      And the following torrents exist:
        | name                      | uploader         |
        | joe_the_uploaders_torrent | joe-the-uploader | 
      And I am logged in as 'joe-the-user'

  Scenario: User adds a reward to a torrent
    Given user 'joe-the-user' attribute 'uploaded' is '10485760'
      And user 'joe-the-uploader' attribute 'uploaded' is '0'
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'rewards'
      And I click link '[ add reward ]'
      And I fill in 'reward_amount' with '10'
      And I select 'MB' from 'reward_unit'
      And I click button 'Confirm'
    Then page should countain text 'Reward successfully added.'
      And page should countain text '10.00 MB'
      And user 'joe-the-uploader' attribute 'uploaded' should be '10485760'
      And user 'joe-the-user' attribute 'uploaded' should be '0'
      And torrent 'joe_the_uploaders_torrent' attribute 'total_reward' should be '10485760'

  Scenario: User tries to add a reward to a torrent having insufficient upload credit
    Given user 'joe-the-user' attribute 'uploaded' is '0'
    When I go to the 'torrent details page for torrent "joe_the_uploaders_torrent"'
      And I click link 'rewards'
      And I click link '[ add reward ]'
      And I fill in 'reward_amount' with '10'
      And I select 'MB' from 'reward_unit'
      And I click button 'Confirm'
    Then page should countain text 'Your upload credit is insufficient.'