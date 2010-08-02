
describe '- models' do 
  
  describe 'User' do
  
    context '- ratio policy:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
      
      it 'should indicate if it is under ratio watch' do
        @user.under_ratio_watch?.should be_false
        
        @user.role = @role_defective
        @user.ratio_watch_until = 30.days.from_now
        @user.save!
        @user.reload
  
        @user.under_ratio_watch?.should be_true
      end
  
      it 'should be put on ratio watch and notify itself' do
        @user.start_ratio_watch! 30.days.from_now
        @user.reload
  
        @user.under_ratio_watch?.should be_true
        @user.role.should == @role_defective
        @user.ratio_watch_until.instance_of?(Time).should be_true
  
        m = find_message_by_receiver_and_subject @user, 'you are under ratio watch'
        m.should_not be_nil
        m.body.should == "Your ratio is in violation of the site rules, you have until #{I18n.l(@user.ratio_watch_until, :format => :date)} to fix it."
      end
  
      it 'should be put out of ratio watch' do
        @user.start_ratio_watch! 30.days.from_now
        @user.reload
  
        @user.end_ratio_watch!
        @user.reload
  
        @user.under_ratio_watch?.should be_false
        @user.role.should == @role_user
        @user.ratio_watch_until.should be_nil
      end
    end
  end
end  
  
  
  

