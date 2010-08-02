
describe '- models' do 
  
  describe 'Torrent' do

    context '- validation:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
       
      it 'should check if name is valid' do
        @torrent.update_with_updater({:name => ''}, @user_uploader).should be_false
        @torrent.errors[:name].should == 'Name required.'
      end
  
      it 'should check if year is valid' do
        @torrent.update_with_updater({:year => '999'}, @user_uploader).should be_false
        @torrent.errors[:year].should == 'Invalid year.'
      end
      
      it 'should check if info hash not taken' do
        torrent_file_data = File.new(File.join(TEST_DATA_DIR, 'valid.torrent'), 'rb').read
        
        t = make_torrent(@user_uploader, nil, nil, nil, false) # unsaved torrent
        t.parse_and_save(torrent_file_data)
        t.reload
        
        new_t = make_torrent(@user_uploader, nil, nil, nil, false) # unsaved torrent
        new_t.parse_and_save(torrent_file_data)
        
        new_t.new_record?.should be_true
        new_t.errors[:info_hash].should == 'Torrent file already uploaded.'
      end  
      
      it 'should raise error if counters are negative' do
        @torrent.seeders_count = -1
        @torrent.leechers_count = 1
        @torrent.rewards_count = 1     
        lambda { @torrent.save }.should raise_error
        
        @torrent.seeders_count = 1
        @torrent.leechers_count = -1
        @torrent.rewards_count = 1
        lambda { @torrent.save }.should raise_error
        
        @torrent.seeders_count = 1
        @torrent.leechers_count = 1
        @torrent.rewards_count = -1
        lambda { @torrent.save }.should raise_error
      end     
    end 
  end    
end