
describe '- models' do 
  
  describe 'Reward' do
  
    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      
        @user_rewarder.credit! 12345
      end
  
      it 'should set its number' do
        @torrent.rewards_count = 0
        @torrent.save!
        @torrent.reload
        
        r = Reward.kreate! @torrent, @user_rewarder, 12345  
        r.reward_number.should == 1
      end
  
      it 'should charge amount from the user who created it on creation' do
        Reward.kreate! @torrent, @user_rewarder, 12345 
        @user_rewarder.reload
    
        @user_rewarder.uploaded.should == 0
      end
  
      it 'should credit amount for torrent user on creation' do
        @user_uploader.uploaded = 0
        @user_uploader.save!
        @user_uploader.reload
        
        Reward.kreate! @torrent, @user_rewarder, 12345 
        @user_uploader.reload
    
        @user_uploader.uploaded.should == 12345
      end
    
      it 'should increment torrent rewards counter on creation' do
        @torrent.rewards_count = 0
        @torrent.save!
        @torrent.reload
    
        Reward.kreate! @torrent, @user_rewarder, 12345 
        @torrent.reload
    
        @torrent.rewards_count.should == 1
      end
    
      it 'should add amount to torrent total reward on creation' do
        @torrent.total_reward = 0
        @torrent.save!
        @torrent.reload
        
        Reward.kreate! @torrent, @user_rewarder, 12345 
        @torrent.reload
    
        @torrent.total_reward.should == 12345
      end
    end
  end
end
