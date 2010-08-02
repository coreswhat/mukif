
  # given

    Given /^I uploaded torrent file '(.*)' as '(.*)'$/ do |file_name, name|
      Given "a type with description 'n_type' exists"
        And "a format with description 'n_format' exists"
      When "I go to the 'torrent upload page'"
        And "I select 'n_type' from 'torrent_type_id'"
        And "I select 'n_format' from 'torrent_format_id'"
        And "I fill in file field 'torrent_file' with '#{file_name}'"
        And "I fill in 'torrent_name' with '#{name}'"
        And "I click button 'Upload'"
      Then "page should countain text 'Torrent Details'"
    end