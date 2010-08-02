
describe '- authentication' do 
  
  describe 'Authentication' do
    
    describe 'UserModel' do
      
      describe 'SessionToken' do
      
        before(:each) do
          clear_database
          load_default_variables
          load_user_variables
        end
    
        it 'should authenticate by session token' do
          @user.session_token = 'n_session_token'
          @user.save!
          @user.reload
          
          User.authenticate_by_session_token(@user.id, 'n_session_token').should == @user
          User.authenticate(@user.id, 'nonono').should be_nil
        end
        
        it 'should not authenticate by session token if user inactive' do
          @user.session_token = 'n_session_token'
          @user.active = false
          @user.save!
          @user.reload
          
          User.authenticate_by_session_token(@user.id, 'n_session_token').should be_nil
        end      
  
         it 'should reset session token' do
          @user.session_token = 'n_session_token'
          @user.save!
          @user.reload
          
          @user.reset_session_token!
          @user.reload     
                
          @user.session_token.should_not be_nil
          @user.session_token.should_not == 'n_session_token'
        end
        
         it 'should clear session token' do
          @user.session_token = 'n_session_token'
          @user.save!
          @user.reload
          
          @user.clear_session_token!
          @user.reload     
                
          @user.session_token.should be_nil
        end
      end
    end
  end
end  
  
  

