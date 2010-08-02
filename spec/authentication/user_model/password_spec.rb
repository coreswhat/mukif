
describe '- authentication' do 
  
  describe 'Authentication' do
    
    describe 'UserModel' do 
      
      describe 'Password' do
      
        before(:each) do
          clear_database
          load_default_variables
          load_user_variables
        end
    
        it 'should authenticate by password' do
          User.authenticate(@user.username, @user.username).should == @user
          User.authenticate(@user.username, 'nonono').should be_nil
        end
        
        it 'should authenticate by password if user inactive' do
          @user.active = false
          @user.save!
          @user.reload
          
          User.authenticate(@user.username, @user.username).should == @user
        end
      end
    end
  end
end




