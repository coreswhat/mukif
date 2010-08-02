
describe '- models' do 
  
  describe 'Torrent' do

    context '- parsing:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should be created receiving a torrent file' do
        torrent_file_data = File.new(File.join(TEST_DATA_DIR, 'valid.torrent'), 'rb').read
  
        t = make_torrent(@user_uploader, nil, nil, nil, false) # make an unsaved torrent
        t.parse_and_save(torrent_file_data)
        t.reload
  
        t.dir_name.should == 'Upload Test'
        t.piece_length.should == 65536
        t.info_hash_hex.should == '54B1A5052B5B7D3BA4760F3BFC1135306A30FFD1'
        t.files_count.should == 3
        t.size.should == t.mapped_files.inject(0) {|s, e| s + e.size}
        
        f = find_mapped_file_by_torrent_and_name_and_size t, '01 - Test One.mp3', 1757335
        f.should_not be_nil
      end
      
      it 'should generate a valid torrent file from stored data' do
        torrent_file_data = File.new(File.join(TEST_DATA_DIR, 'valid.torrent'), 'rb').read
        t = make_torrent(@user_uploader, nil, nil, nil, false) # make an unsaved torrent
        t.parse_and_save(torrent_file_data)
        t.reload
  
        generated_torrent_file = t.out
  
        lambda { 
          Bittorrent::TorrentFile.parse_torrent_file(generated_torrent_file) 
        }.should_not raise_error(Bittorrent::TorrentFile::InvalidTorrentError) 
      end
    end
  end
end