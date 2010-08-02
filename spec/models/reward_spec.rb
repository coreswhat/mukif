
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'reward_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Reward' do

    context '- main class:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        
        @user_rewarder.credit! 12345
      end
        
      it 'should be created given valid parameters' do
        Reward.kreate! @torrent, @user_rewarder, 12345      
        r = find_reward_by_torrent_and_user_and_amount @torrent, @user_rewarder, 12345
        r.should_not be_nil
      end
    end
  end
end