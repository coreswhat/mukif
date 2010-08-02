
describe '- models' do 
  
  describe 'Peer' do

    context '- tasks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
        load_torrent_variables
      end
      
      it 'should destroy inactive peers' do
        seeders_count = @torrent.seeders_count
        
        peer_one = make_peer @torrent, @user, '0.0.0.0', 10000, true
        peer_one.last_action_at = 2.days.ago
        peer_one.save!
        peer_one.reload
        
        peer_two = make_peer @torrent, @user_two, '0.0.0.0', 10000, true
        peer_two.last_action_at = 1.hour.ago
        peer_two.save!
        peer_two.reload
  
        peer_three = make_peer @torrent, @user_three, '0.0.0.0', 10000, false
        peer_three.last_action_at = 2.days.ago
        peer_three.save!
        peer_three.reload
  
        peer_four = make_peer @torrent, @user_four, '0.0.0.0', 10000, false
        peer_four.last_action_at = 1.hour.ago
        peer_four.save!
        peer_four.reload
        
        @torrent.seeders_count = 2 # manually as only the tracker app has callbacks for creation
        @torrent.leechers_count = 2
        @torrent.save!
        
        Peer.destroy_inactives 1.day.ago      
        @torrent.reload
        
        find_peer_by_torrent_and_user_and_ip_and_port(@torrent, @user, '0.0.0.0', 10000).should be_nil
        find_peer_by_torrent_and_user_and_ip_and_port(@torrent, @user_two, '0.0.0.0', 10000).should_not be_nil
        find_peer_by_torrent_and_user_and_ip_and_port(@torrent, @user_three, '0.0.0.0', 10000).should be_nil
        find_peer_by_torrent_and_user_and_ip_and_port(@torrent, @user_four, '0.0.0.0', 10000).should_not be_nil
  
        @torrent.seeders_count.should == 1
        @torrent.leechers_count.should == 1
      end
    end
  end
end