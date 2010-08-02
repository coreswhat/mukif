
  # then
  
    Then /^downloaded torrent should have same info hash as torrent '(.*)'$/ do |torrent_name|
      t = make_torrent(nil, nil, nil, nil, false)
      t.parse_and_save(body, false) # false because it should already contain the private flag 
            
      t.info_hash.should == find_torrent_by_name(torrent_name).info_hash
    end