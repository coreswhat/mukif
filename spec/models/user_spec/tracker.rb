
describe '- models' do 
  
  describe 'User' do

    context '- tracker:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
  
      it 'should calculate ratio' do
        User.calculate_ratio(50, 0).should == 0
        User.calculate_ratio(50, 100).should == 0.5
      end
  
      it 'should reset passkey and notify itself when passkey reset by an admin' do
        old_passkey = @user.passkey
  
        @user.reset_passkey_with_notification(@admin)
        @user.reload
  
        @user.passkey.should_not == old_passkey
  
        m = find_message_by_receiver_and_subject @user, 'passkey reset'
        m.should_not be_nil
        m.body.should == 'Your passkey was reset for security reasons, please re-download your active torrents.'
      end
    end
  end
end




