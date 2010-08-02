
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')
  
describe '- authorization' do 
  
  describe 'Authorization' do
    
    describe 'UserModel' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
  
      it 'should indicate if has role system' do
        @user_system.system?.should be_true
        @user_owner.system?.should be_false
        @user_admin.system?.should be_false
        @user_mod.system?.should be_false
        @user.system?.should be_false
        @user_defective.system?.should be_false
        @user_power_user.system?.should be_false
      end
  
      it 'should indicate if has role owner' do
        @user_system.owner?.should be_true
        @user_owner.owner?.should be_true
        @user_admin.owner?.should be_false
        @user_mod.owner?.should be_false
        @user.owner?.should be_false
        @user_defective.owner?.should be_false
        @user_power_user.owner?.should be_false
      end
  
      it 'should indicate if has role admin' do
        @user_system.admin?.should be_true
        @user_owner.admin?.should be_true
        @user_admin.admin?.should be_true
        @user_mod.admin?.should be_false
        @user.admin?.should be_false
        @user_defective.admin?.should be_false
        @user_power_user.admin?.should be_false
      end
  
      it 'should indicate if has role admin or moderator' do
        @user_system.admin_mod?.should be_true
        @user_owner.admin_mod?.should be_true
        @user_admin.admin_mod?.should be_true
        @user_mod.admin_mod?.should be_true
        @user.admin_mod?.should be_false
        @user_defective.admin_mod?.should be_false
        @user_power_user.admin_mod?.should be_false
      end
  
      it 'should indicate if has role moderator' do
        @user_system.mod?.should be_false
        @user_owner.mod?.should be_false
        @user_admin.mod?.should be_false
        @user_mod.mod?.should be_true
        @user.mod?.should be_false
        @user_defective.mod?.should be_false
        @user_power_user.mod?.should be_false
      end
   
      it 'should indicate if has role defective' do
        @user_system.defective?.should be_false
        @user_owner.defective?.should be_false
        @user_admin.defective?.should be_false
        @user_mod.defective?.should be_false
        @user.defective?.should be_false
        @user_defective.defective?.should be_true
        @user_power_user.defective?.should be_false
      end
      
      it 'should indicate if is staff member' do
        @user_two.add_extra_ticket! :staff
        @user_two.reload 
        
        @user_system.staff?.should be_true
        @user_owner.staff?.should be_true
        @user_admin.staff?.should be_true
        @user_mod.staff?.should be_true
        @user.staff?.should be_false
        @user_two.staff?.should be_true
        @user_defective.staff?.should be_false
        @user_power_user.staff?.should be_false
      end     
  
      it 'should authorize by role ticket' do
        @user.role.tickets = 'new_ticket_one'
        @user.has_ticket?(:new_ticket_one).should be_true
        @user.has_ticket?(:new_ticket_two).should be_false
      end
  
      it 'should authorize by extra ticket' do
        @user.extra_tickets = 'new_extra_ticket_one'
        @user.has_ticket?(:new_extra_ticket_one).should be_true
        @user.has_ticket?(:new_extra_ticket_two).should be_false
      end
  
      it 'should add an extra ticket' do
        @user.extra_tickets = 'new_extra_ticket_one'
        @user.save!
        @user.reload
        
        @user.add_extra_ticket!(:new_extra_ticket_two)
        @user.reload
  
        @user.has_ticket?(:new_extra_ticket_one).should be_true
        @user.has_ticket?(:new_extra_ticket_two).should be_true
        @user.has_ticket?(:new_extra_ticket_three).should be_false
      end
  
      it 'should remove an extra ticket' do
        @user.add_extra_ticket!(:new_extra_ticket_one)
        @user.add_extra_ticket!(:new_extra_ticket_two)
        @user.reload
  
        @user.remove_extra_ticket!(:new_extra_ticket_one)
        @user.reload
  
        @user.has_ticket?(:new_extra_ticket_one).should be_false
        @user.has_ticket?(:new_extra_ticket_two).should be_true
      end
    end
  end
end