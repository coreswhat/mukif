
describe '- models' do 
  
  describe 'User' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
      
      # new record validations
      
        it 'should check if username is valid when new record' do
          new_user = make_user('', @role_user, false)
          new_user.save_new_with_invitation(nil, false)
          new_user.errors[:username].should == 'Username required.'
    
          new_user_two = make_user('jo', @role_user, false)
          new_user_two.save_new_with_invitation(nil, false)
          new_user_two.errors[:username].should == 'Length must be between 3 and 20.'
          
          new_user_three = make_user('user$n&ame', @role_user, false)
          new_user_three.save_new_with_invitation(nil, false)
          new_user_three.errors[:username].should == 'Use letters, numbers, underscore or dash.'
          
          new_user_four = make_user(@user_untouched.username, @role_user, false)
          new_user_four.save_new_with_invitation(nil, false)
          new_user_four.errors[:username].should == 'Username already in use.'
        end
        
        it 'should check if password is valid when new record' do
          new_user = make_user('joe-the-new-user', @role_user, false)
          new_user.password = new_user.password_confirmation = ''
          new_user.save_new_with_invitation(nil, false)
          new_user.errors[:password].should == 'Password required.'
    
          new_user_two = make_user('joe-the-new-two', @role_user, false)
          new_user_two.password = 'new'
          new_user_two.password_confirmation = ''
          new_user_two.save_new_with_invitation(nil, false)
          new_user_two.errors[:password].should == 'Length must be between 5 and 40.'
          
          new_user_three = make_user('joe-the-new-three', @role_user, false)
          new_user_three.password = 'new_password'
          new_user_three.password_confirmation = ''
          new_user_three.save_new_with_invitation(nil, false)
          new_user_three.errors[:password_confirmation].should == 'Incorrect password confirmation.'
          
          new_user_four = make_user('joe-the-new-four', @role_user, false)
          new_user_four.password = 'new_password'
          new_user_four.password_confirmation = 'nonono'
          new_user_four.save_new_with_invitation(nil, false)
          new_user_four.errors[:password_confirmation].should == 'Incorrect password confirmation.'      
        end
    
        it 'should check if email is valid when new record' do
          new_user = make_user('joe-the-new-user', @role_user, false)
          new_user.email = ''
          new_user.save_new_with_invitation(nil, false)
          new_user.errors[:email].should == 'Email required.'
    
          new_user_two = make_user('joe-the-new-two', @role_user, false)
          new_user_two.email = 'new@mail'
          new_user_two.save_new_with_invitation(nil, false)
          new_user_two.errors[:email].should == 'Invalid email.'
    
          new_user_three = make_user('joe-the-new-three', @role_user, false)
          new_user_three.email = @user_untouched.email
          new_user_three.save_new_with_invitation(nil, false)
          new_user_three.errors[:email].should == 'Email already in use.'     
        end
            
      # update validations
  
        it 'should require current password if user updating itself and user not admin' do        
          @user.update_with_updater({}, @user, '').should be_false
          @user.errors[:current_password].should == 'Current password required.'
  
          @user_two.update_with_updater({}, @user_two, 'nonono').should be_false
          @user_two.errors[:current_password].should == 'Current password incorrect.'
        end
  
        it 'should check if new password is valid when updated' do
          @user.update_with_updater({:password => 'up'}, @user, @user.username).should be_false
          @user.errors[:password].should == 'Length must be between 5 and 40.'
          
          @user_two.update_with_updater({:password => 'updated_password'}, @user_two, @user_two.username).should be_false
          @user_two.errors[:password_confirmation].should == 'Incorrect password confirmation.'
          
          @user_three.update_with_updater({:password => 'updated_password', :password_confirmation => 'nonono'}, @user_three, @user_three.username).should be_false
          @user_three.errors[:password_confirmation].should == 'Incorrect password confirmation.'
        end
  
        it 'should check if email is valid when updated' do
          @user.update_with_updater({:email => ''}, @user, @user.username).should be_false
          @user.errors[:email].should == 'Email required.'
          
          @user_two.update_with_updater({:email => 'updated@mail'}, @user_two, @user_two.username).should be_false
          @user_two.errors[:email].should == 'Invalid email.'
          
          @user_three.update_with_updater({:email => @user_untouched.email}, @user_three, @user_three.username).should be_false
          @user_three.errors[:email].should == 'Email already in use.'
        end 
  
        it 'should check if username is valid when updated by an admin' do
          @user.update_with_updater({:username => ''}, @user_admin, nil).should be_false
          @user.errors[:username].should == 'Username required.'
          
          @user_two.update_with_updater({:username => 'up'}, @user_admin, nil).should be_false
          @user_two.errors[:username].should == 'Length must be between 3 and 20.'
          
          @user_three.update_with_updater({:username => 'u&dated_us$rname'}, @user_admin, nil).should be_false
          @user_three.errors[:username].should == 'Use letters, numbers, underscore or dash.'
          
          @user_four.update_with_updater({:username => @user_untouched.username}, @user_admin, nil).should be_false
          @user_four.errors[:username].should == 'Username already in use.'
        end
        
      # all
      
        it 'should raise error if counters are negative' do
          @user.downloaded = -1
          @user.uploaded = 1
          lambda { @user.save }.should raise_error      
          
          @user.downloaded = 1
          @user.uploaded = -1
          lambda { @user.save }.should raise_error               
        end
    end
  end
end

