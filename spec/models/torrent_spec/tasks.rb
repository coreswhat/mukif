
describe '- models' do 
  
  describe 'Torrent' do

    context '- tasks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
      
      it 'should reset free status for torrents based on free until time' do      
        @torrent.free = true
        @torrent.free_until = 1.hour.ago
        @torrent.save!   
        
        @torrent_two.free = true
        @torrent_two.free_until = nil
        @torrent_two.save!   
        
        @torrent_three.free = true
        @torrent_three.free_until = 1.day.from_now
        @torrent_three.save!
              
        Torrent.reset_expired_free_period
        
        @torrent.reload
        @torrent_two.reload
  
        @torrent.free.should be_false
        @torrent.free_until.should be_nil
        
        @torrent_two.free.should be_true
        @torrent_two.free_until.should be_nil
        
        @torrent_three.free.should be_true
        @torrent_three.free_until.instance_of?(Time).should be_true
      end
    end
  end
end