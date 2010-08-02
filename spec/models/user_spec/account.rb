
describe '- models' do 
  
  describe 'User' do

    context '- account:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
  
      it 'should save new record with invitation code if invitation is required' do
        invitation = make_invitation(@user, 'joe-the-new-user@mail.com')
        
        new_user = make_user('joe-the-new-user', @role_user, false)
  
        new_user.save_new_with_invitation(invitation.code, true)
        new_user.reload
  
        new_user.new_record?.should be_false
        new_user.inviter.should == @user
        
        i = find_invitation_by_code invitation.code
        i.should be_nil
      end
      
      it 'should not save new record with invalid invitation code if invitation is required' do
        new_user = make_user('joe-the-new-user', @role_user, false)
  
        new_user.save_new_with_invitation('nononononono', true)
  
        new_user.new_record?.should be_true
        new_user.errors[:invitation_code].should == 'Invitation code invalid.'
      end    
  
      it 'should not save new record without invitation code if invitation is required' do
        new_user = make_user('joe-the-new-user', @role_user, false)
  
        new_user.save_new_with_invitation('', true)
  
        new_user.new_record?.should be_true
        new_user.errors[:invitation_code].should == 'Invitation code required.'
      end    
      
      it 'should save new record without invitation code if invitation is not required' do
        new_user = make_user('joe-the-new-user', @role_user, false)
  
        new_user.save_new_with_invitation('', false)
        new_user.reload
  
        new_user.new_record?.should be_false
        new_user.inviter.should be_nil
      end  
      
      it 'should save new record with invalid invitation code if invitation is not required' do
        new_user = make_user('joe-the-new-user', @role_user, false)
  
        new_user.save_new_with_invitation('nononononono', false)
        new_user.reload
  
        new_user.new_record?.should be_false
        new_user.inviter.should be_nil
      end   
    end
  end
end




