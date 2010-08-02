
describe '- authentication' do 
  
  describe 'Authentication' do
    
    describe 'UserModel' do
      
      describe 'RememberToken' do
      
        before(:each) do
          clear_database
          load_default_variables
          load_user_variables
        end
    
        it 'should authenticate by remember token' do
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.from_now
          @user.save!
          @user.reload 
          
          User.authenticate_by_remember_token('n_remember_token').should == @user
          User.authenticate_by_remember_token('nonono').should be_nil
        end
        
        it 'should not authenticate by remember token if remember token expired' do            
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.ago
          @user.save!
          @user.reload     
                
          User.authenticate_by_remember_token('n_remember_token').should be_nil        
        end
        
        it 'should not authenticate by remember token if user inactive' do            
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.from_now
          @user.active = false
          @user.save!
          @user.reload     
                
          User.authenticate_by_remember_token('n_remember_token').should be_nil        
        end      
        
         it 'should set remember token and remember token expiration' do
          @user.remember_token, @user.remember_token_expires_at = nil, nil
          @user.save!
          @user.reload
          
          @user.remember_me_for 1.day
          @user.reload     
                
          @user.remember_token.should_not be_nil        
          @user.remember_token_expires_at.instance_of?(Time).should be_true
        end
        
         it 'should clear remember token and remember token expiration' do
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.ago
          @user.save!
          @user.reload
          
          @user.clear_remember_token!
          @user.reload     
                
          @user.remember_token.should be_nil        
          @user.remember_token_expires_at.should be_nil
        end
      end
    end
  end
end            
                  
    