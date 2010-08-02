
  # given
    
   Given /the following torrents exist:/ do |table|
      table.hashes.each do |h|
        t = make_torrent find_user_by_username(h['uploader']), h['name']
      end
    end

    Given /^torrent '(.*)' is inactivated$/ do |name|
      t = find_torrent_by_name(name)
      t.active = false
      t.save!
    end
    
    Given /^torrent '(.*)' is deleted$/ do |name|
      t = find_torrent_by_name(name)
      t.destroy
    end
    
    Given /^torrent '(.*)' attribute '(.*)' is '(.*)'$/ do |name, attribute, value|
      t = find_torrent_by_name name
      t.send(attribute + '=', value)
      t.save!
    end 

  # then

    Then /^torrent '(.*)' should exist with attributes:$/ do |name, table|
      t = find_torrent_by_name(name)
      t.should_not be_nil
        
      t_table = [ ['type', 'format', 'source', 'uploader', 'description', 'files', 'piece length'],
                  [t.type.description, t.format.description, t.source.description, (t.user ? t.user.username : ''), t.description, t.mapped_files.size.to_s, t.piece_length.to_s] ]
                         
      table.diff!(t_table)
    end 
    
    Then /^the following torrents should exist:$/ do |table|
      a = find_torrents
        
      t_table = [ ['type', 'name', 'format', 'source', 'uploader', 'description'] ]
      a.each {|e| t_table << [e.type.description, e.name, e.format.description, e.source.description, (e.user ? e.user.username : ''), e.description] }
      table.diff!(t_table)
    end 

    Then /^torrent '(.*)' should not exist$/ do |name|
      find_torrent_by_name(name).should be_nil
    end            
  
    Then /^torrent '(.*)' attribute '(.*)' should be '(.*)'$/ do |name, attribute, value|
      t = find_torrent_by_name name
      t.send(attribute.to_sym).to_s.should == value
    end 




