
describe '- models' do 
  
  describe 'User' do

    context '- tasks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
      
      it 'should put users under ratio watch based on their downloaded counters and ratios' do
        min_downloaded = 100
        max_downloaded = 500
        min_ratio = 0.5
  
        @user.uploaded, @user.downloaded = 100, 400 # ratio 0.25
        @user.ratio = User.calculate_ratio(@user.uploaded, @user.downloaded)
        @user.save!
        
        @user_two.uploaded, @user_two.downloaded = 400, 400  # ratio 1
        @user_two.ratio = User.calculate_ratio(@user_two.uploaded, @user_two.downloaded)
        @user_two.save!
        
        @user_power_user.uploaded, @user_power_user.downloaded = 100, 400  # ratio 0.25
        @user_power_user.ratio = User.calculate_ratio(@user_power_user.uploaded, @user_power_user.downloaded)
        @user_power_user.save!
        
        User.start_ratio_watch(min_downloaded, max_downloaded, min_ratio, 30.days.from_now)
        
        @user.reload
        @user_two.reload
        @user_power_user.reload
  
        @user.role.should == @role_defective
        @user_two.role.should == @role_user
        @user_power_user.role.should == @role_defective
      end
  
      it 'should end users ratio watch' do
        min_downloaded = 100
        max_downloaded = 500
        min_ratio = 0.5
  
        @user.uploaded, @user.downloaded = 400, 400 # ratio 1
        @user.ratio = User.calculate_ratio(@user.uploaded, @user.downloaded)
        @user.role = @role_defective
        @user.ratio_watch_until = 1.day.ago
        @user.save!
  
        @user_two.uploaded, @user_two.downloaded = 100, 400 # ratio 0.25
        @user_two.ratio = User.calculate_ratio(@user_two.uploaded, @user_two.downloaded)
        @user_two.role = @role_defective
        @user_two.ratio_watch_until = 1.day.ago
        make_torrent(@user_two) # so it won't be removed, only inactivated
        @user_two.save!
  
        @user_three.uploaded, @user_three.downloaded = 100, 400 # ratio 0.25
        @user_three.ratio = User.calculate_ratio(@user_three.uploaded, @user_three.downloaded)
        @user_three.role = @role_defective
        @user_three.ratio_watch_until = 1.day.ago
        @user_three.save!
  
        User.finish_ratio_watch(min_downloaded, max_downloaded, min_ratio)
        
        @user.reload
        @user_two.reload
  
        @user.role.should == @role_user
        
        @user_two.role.should == @role_defective
        @user_two.active.should be_false
        
        find_user_by_username(@user_three.username).should be_nil
      end
  
      it 'should promote or demote users based on their data transfer counters and ratios' do
        min_uploaded = 100
        min_ratio = 0.5
  
        @user.uploaded, @user.downloaded = 200, 200 # ratio 1
        @user.ratio = User.calculate_ratio(@user.uploaded, @user.downloaded)
        @user.save!
        
        @user_two.uploaded, @user_two.downloaded = 200, 800 # ratio 0.25
        @user_two.ratio = User.calculate_ratio(@user_two.uploaded, @user_two.downloaded)
        @user_two.save!
        
        @user_power_user.uploaded, @user_power_user.downloaded = 200, 200 # ratio 1
        @user_power_user.ratio = User.calculate_ratio(@user_power_user.uploaded, @user_power_user.downloaded)
        @user_power_user.save!
        
        @user_power_user_two.uploaded, @user_power_user_two.downloaded = 200, 800 # ratio 0.25
        @user_power_user_two.ratio = User.calculate_ratio(@user_power_user_two.uploaded, @user_power_user_two.downloaded)
        @user_power_user_two.save!
  
        User.promote_demote_by_data_transfer(@role_user.name, @role_power_user.name, min_uploaded, min_ratio)
        
        @user.reload
        @user_two.reload
        @user_power_user.reload
        @user_power_user_two.reload
  
        @user.role.should == @role_power_user
        @user_two.role.should == @role_user
        @user_power_user.role.should == @role_power_user
        @user_power_user_two.role.should == @role_user
      end
    end
  end
end

