
describe '- models' do 
  
  describe 'Reward' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        
        @user_rewarder.credit! 12345
        @reward = make_reward @torrent, @user_rewarder, 12345
      end
  
      it 'should check if amount is valid' do
        @reward.update_attributes({:amount => ''}).should be_false
        @reward.errors[:amount].should == 'Amount required.'
      end
    end
  end
end
