
Feature: Torrent Upload
  In order to have my torrents in the system
  As a registered user
  I want to be able to upload them

  Background:    
    Given the following users exist:
      | username     | role |
      | joe-the-user | user |
      And a type with description 'n_type' exists
      And a format with description 'n_format' exists
      And a source with description 'n_source' exists
      And I am logged in as 'joe-the-user'

  Scenario: User uploads a torrent
    When I go to the 'torrent upload page'
      And I select 'n_type' from 'torrent_type_id'
      And I fill in file field 'torrent_file' with 'valid.torrent'
      And I fill in 'torrent_name' with 'joe_the_users_torrent'
      And I select 'n_format' from 'torrent_format_id'
      And I select 'n_source' from 'torrent_source_id'
      And I fill in 'torrent_description' with 'n_description'
      And I click button 'Upload'
    Then page should countain text 'Your personal announce url was added to the torrent, please re-download it.'
      And page should countain text 'joe_the_users_torrent.torrent'
      And page should countain text '54B1A5052B5B7D3BA4760F3BFC1135306A30FFD1'
      And torrent 'joe_the_users_torrent' should exist with attributes:
        | type   | format   | source   | uploader     | description   | files | piece length |        
        | n_type | n_format | n_source | joe-the-user | n_description | 3     | 65536        |

  Scenario: User uploads a torrent anonymously
    When I go to the 'torrent upload page'
      And I select 'n_type' from 'torrent_type_id'
      And I fill in file field 'torrent_file' with 'valid.torrent'
      And I fill in 'torrent_name' with 'joe_the_users_torrent'
      And I select 'n_format' from 'torrent_format_id'
      And I select 'n_source' from 'torrent_source_id'
      And I check 'anonymous'
      And I click button 'Upload'
    Then torrent 'joe_the_users_torrent' should exist with attributes:
      | type   | format   | source   | uploader | files | piece length |        
      | n_type | n_format | n_source |          | 3     | 65536        |
        
  Scenario: User tries to upload an invalid torrent file
    When I go to the 'torrent upload page'
      And I fill in file field 'torrent_file' with 'invalid.torrent'
      And I select 'n_type' from 'torrent_type_id'
      And I fill in 'torrent_name' with 'joe_the_users_torrent'
      And I select 'n_format' from 'torrent_format_id'
      And I click button 'Upload'
    Then page should countain text 'Invalid torrent file.'

  Scenario: User tries to upload a file of another type
    When I go to the 'torrent upload page'
      And I fill in file field 'torrent_file' with 'test.txt'
      And I select 'n_type' from 'torrent_type_id'
      And I fill in 'torrent_name' with 'joe_the_users_torrent'
      And I select 'n_format' from 'torrent_format_id'
      And I click button 'Upload'
    Then page should countain text 'Must be a file of type torrent.'






