
Feature: Torrent Edition
  In order to change a torrents information
  As a registered user
  I want to be able to edit them

  Background:    
    Given the following users exist:
      | username     | role | email                 |
      | joe-the-user | user | joe-the-user@mail.com |
      And the following torrents exist:
        | name                  | uploader     |
        | joe_the_users_torrent | joe-the-user |       
      And a type with description 'e_type' exists
      And a format with description 'e_format' exists
      And a source with description 'e_source' exists
      And I am logged in as 'joe-the-user'

  Scenario: User updates its own torrent
    When I go to the 'torrent details page for torrent "joe_the_users_torrent"'
      And I click link 'edit'
      And I select 'e_type' from 'torrent_type_id'
      And I fill in 'torrent_name' with 'e_name'
      And I select 'e_format' from 'torrent_format_id'
      And I select 'e_source' from 'torrent_source_id'
      And I fill in 'torrent_description' with 'e_description'
      And I click button 'Edit'
    Then page should countain text 'Torrent successfully edited.'
      And the following torrents should exist:
        | type   | name   | format   | source   | uploader     | description   |        
        | e_type | e_name | e_format | e_source | joe-the-user | e_description |



