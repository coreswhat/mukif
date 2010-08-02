
describe '- models' do 
  
  describe 'User' do

    context '- account recovery:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
  
      it 'should reset password given the valid parameters' do
        @user.reset_password('reset_pass', 'reset_pass').should be_true
        @user.reload
        User.authenticate(@user.username, 'reset_pass').should == @user
      end
  
      it 'should not reset password if password empty' do
        @user.reset_password('', '')
        @user.errors[:password].should == 'Password required.'
      end
      
      it 'should not reset password if password has invalid size' do
        @user.reset_password('no', 'no')
        @user.errors[:password].should == 'Length must be between 5 and 40.'
      end
      
      it 'should not reset password if password does not match password confirmation' do
        @user.reset_password('reset_pass', 'nonono')
        @user.errors[:password_confirmation].should == 'Incorrect password confirmation.'
      end    
    end    
  end
end  
  
  


