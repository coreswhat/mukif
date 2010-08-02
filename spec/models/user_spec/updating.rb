
describe '- models' do 
  
  describe 'User' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
  
      # editable_by rules
  
        it 'should be editable only by itself if system' do
          @user_system.editable_by?(@user_system).should be_true
          @user_system.editable_by?(@user).should be_false
          @user_system.editable_by?(@user_mod).should be_false
          @user_system.editable_by?(@user_admin).should be_false
          @user_system.editable_by?(@user_owner).should be_false
        end
  
        it 'should be editable only by itself or system if an owner' do
          @user_owner.editable_by?(@user_owner).should be_true
          @user_owner.editable_by?(@user).should be_false
          @user_owner.editable_by?(@user_mod).should be_false
          @user_owner.editable_by?(@user_admin).should be_false
          @user_owner.editable_by?(@user_owner_two).should be_false
          @user_owner.editable_by?(@user_system).should be_true
        end
  
        it 'should be editable by itself or by an owner if an admin' do
          @user_admin.editable_by?(@user_admin).should be_true
          @user_admin.editable_by?(@user).should be_false
          @user_admin.editable_by?(@user_mod).should be_false
          @user_admin.editable_by?(@user_admin_two).should be_false
          @user_admin.editable_by?(@user_owner).should be_true
          @user_admin.editable_by?(@user_system).should be_true
        end
  
        it 'should be editable by itself or an admin if a moderator' do
          @user_mod.editable_by?(@user_mod).should be_true
          @user_mod.editable_by?(@user).should be_false
          @user_mod.editable_by?(@user_mod_two).should be_false
          @user_mod.editable_by?(@user_admin).should be_true
          @user_mod.editable_by?(@user_owner).should be_true
          @user_mod.editable_by?(@user_system).should be_true
        end
  
        it 'should be editable by itself or an admin if a regular user' do
          @user.editable_by?(@user).should be_true
          @user.editable_by?(@user_two).should be_false # 'user' role behaves like any other custom role
          @user.editable_by?(@user_mod).should be_false
          @user.editable_by?(@user_admin).should be_true
          @user.editable_by?(@user_owner).should be_true
          @user.editable_by?(@user_system).should be_true
        end
  
      # role assignment rules
  
        it 'should not allow system to change its role' do
          @user_system.update_with_updater({:role_id => @user.role.id}, @user_system, nil)
          @user_system.errors[:role_id].should == 'system cannot be demoted!'
        end
  
        it 'should not allow system to assign role system to another user' do
          @user.update_with_updater({:role_id => @user_system.role.id}, @user_system, nil)
          @user.errors[:role_id].should == 'forbidden assignment!'
        end
  
        it 'should not allow an owner to assign role system to another user or itself' do
          @user_owner.update_with_updater({:role_id => @user_system.role.id}, @user_owner, nil)
          @user_owner.errors[:role_id].should == 'forbidden assignment!'
  
          @user.update_with_updater({:role_id => @user_system.role.id}, @user_owner, nil)
          @user.errors[:role_id].should == 'forbidden assignment!'
        end
  
        it 'should not allow an owner to assign role owner to another user' do
          @user.update_with_updater({:role_id => @user_owner.role.id}, @user_owner, nil)
          @user.errors[:role_id].should == 'forbidden assignment!'
        end
  
        it 'should not allow an admin to assign role system to another user or itself' do
          @user_admin.update_with_updater({:role_id => @user_system.role.id}, @user_admin, nil)
          @user_admin.errors[:role_id].should == 'forbidden assignment!'
  
          @user.update_with_updater({:role_id => @user_system.role.id}, @user_admin, nil)
          @user.errors[:role_id].should == 'forbidden assignment!'
        end
  
        it 'should not allow an admin to assign role owner to another user or itself' do
          @user_admin.update_with_updater({:role_id => @user_owner.role.id}, @user_admin, nil)
          @user_admin.errors[:role_id].should == 'forbidden assignment!'
  
          @user.update_with_updater({:role_id => @user_owner.role.id}, @user_admin, nil)
          @user.errors[:role_id].should == 'forbidden assignment!'
        end
  
        it 'should not allow an admin to assign role admin to another user' do
          @user.update_with_updater({:role_id => @user_admin.role.id}, @user_admin, nil)
          @user.errors[:role_id].should == 'forbidden assignment!'
        end
  
      # update
  
        it 'should be updated by itself given the valid parameters' do        
          e_style   = make_style('e_style')
          e_gender  = make_gender('e_gender')        
          e_country = make_country('e_country')
                  
          @user.default_types = nil
          @user.display_last_request_at = false
          @user.display_uploads = false
          @user.display_snatches = false
          @user.display_seeding = false
          @user.display_leeching = false
          @user.delete_on_reply = false
          @user.save_sent= false
          @user.save!
          @user.reload
          
          params = { :password => 'e_password',
                     :password_confirmation => 'e_password',
                     :email => 'e_email@mail.com',
                     :avatar => 'e_avatar',
                     :info => 'e_info',
                     :default_types => ['1', '2'],     
                     :style_id => e_style.id.to_s,
                     :gender_id => e_gender.id.to_s,              
                     :country_id => e_country.id.to_s,
                     :display_last_request_at => '1',
                     :display_uploads => '1',
                     :display_snatches => '1',
                     :display_seeding => '1',
                     :display_leeching => '1',
                     :delete_on_reply => '1',
                     :save_sent => '1' }
  
          @user.update_with_updater(params, @user, @user.username)
          @user.reload
  
          User.authenticate(@user.username, 'e_password').should == @user
          @user.email.should == 'e_email@mail.com'
          @user.avatar.should == 'e_avatar'
          @user.info.should == 'e_info'
          @user.default_types_a.sort.should == ['1', '2']
          @user.style.should == e_style
          @user.gender.should == e_gender
          @user.country.should == e_country
          @user.display_last_request_at.should be_true
          @user.display_uploads.should be_true
          @user.display_snatches.should be_true
          @user.display_seeding.should be_true
          @user.display_leeching.should be_true
          @user.delete_on_reply.should be_true
          @user.save_sent.should be_true
        end
        
        it 'should be updated by an admin given the valid parameters' do        
          e_style   = make_style('e_style')
          e_gender  = make_gender('e_gender')        
          e_country = make_country('e_country')
                  
          @user.default_types = nil
          @user.display_last_request_at = false
          @user.display_uploads = false
          @user.display_snatches = false
          @user.display_seeding = false
          @user.display_leeching = false
          @user.delete_on_reply = false
          @user.save_sent= false
          # administrative attributes
          @user.extra_tickets = nil
          @user.staff_info = nil
          @user.ratio_watch_until = nil
          
          @user.save!
          @user.reload
          
          params = { :password => 'e_password',
                     :password_confirmation => 'e_password',
                     :email => 'e_email@mail.com',
                     :avatar => 'e_avatar',
                     :info => 'e_info',
                     :default_types => ['1', '2'],     
                     :style_id => e_style.id.to_s,
                     :gender_id => e_gender.id.to_s,              
                     :country_id => e_country.id.to_s,
                     :display_last_request_at => '1',
                     :display_uploads => '1',
                     :display_snatches => '1',
                     :display_seeding => '1',
                     :display_leeching => '1',
                     :delete_on_reply => '1',
                     :save_sent => '1',
                     # administrative attributes 
                     :username => 'e_username',
                     :role_id => @role_mod.id.to_s,
                     :extra_tickets => 'one two',
                     :active => '',
                     :staff_info => 'e_staff_info',
                     :ratio_watch_until => '2100-12-12 00:00:00',     
                     :uploaded => '50',
                     :downloaded => '100' }
               
          @user.update_with_updater(params, @user_admin, nil, true).should be_true
          @user.reload
  
          User.authenticate(@user.username, 'e_password').should == @user
          @user.email.should == 'e_email@mail.com'
          @user.avatar.should == 'e_avatar'
          @user.info.should == 'e_info'
          @user.default_types_a.sort.should == ['1', '2']
          @user.style.should == e_style
          @user.gender.should == e_gender
          @user.country.should == e_country
          @user.display_last_request_at.should be_true
          @user.display_uploads.should be_true
          @user.display_snatches.should be_true
          @user.display_seeding.should be_true
          @user.display_leeching.should be_true
          @user.delete_on_reply.should be_true
          @user.save_sent.should be_true
          # administrative attributes
          @user.username.should == 'e_username'
          @user.role.should == @role_mod
          @user.has_ticket?(:one).should be_true
          @user.has_ticket?(:two).should be_true
          @user.active?.should be_false
          @user.staff_info.should == 'e_staff_info'
          @user.ratio_watch_until.to_s.include?('2100-12-12').should be_true
          @user.uploaded == 50
          @user.downloaded == 100
          @user.ratio == 0.500
        end      
    end
  end
end




