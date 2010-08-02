
describe '- models' do 
  
  describe 'Peer' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should decrement torrent seeders counter on destruction' do
        p = make_peer @torrent, @user, '0.0.0.0', 10000, true
        
        @torrent.seeders_count = 1 # manually as only the tracker app has callbacks for creation
        @torrent.save!
        @torrent.reload
        
        p.destroy
        @torrent.reload
  
        @torrent.seeders_count.should == 0
      end
  
      it 'should decrement torrent leechers counter on destruction' do
        p = make_peer @torrent, @user, '0.0.0.0', 10000, false
        
        @torrent.leechers_count = 1 # manually as only the tracker app has callbacks for creation
        @torrent.save!
        @torrent.reload
        
        p.destroy
        @torrent.reload
  
        @torrent.leechers_count.should == 0
      end
    end
  end
end




