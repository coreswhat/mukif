
  # given
  
    Given /^a snatch for torrent '(.*)' and user '(.*)' exists$/ do |torrent_name, username|
      make_snatch find_torrent_by_name(torrent_name), find_user_by_username(username)
    end