
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')
  
describe '- authorization' do 
  
  describe 'Authorization' do
    
    describe 'RoleModel' do

      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
  
      it 'should authorize by ticket' do
        @role_user.tickets = 'new_ticket_one'
        @role_user.has_ticket?(:new_ticket_one).should be_true
        @role_user.has_ticket?(:new_ticket_two).should be_false
      end
  
      it 'should indicate if is reserved' do
        @role_system.reserved?.should be_true
        @role_owner.reserved?.should be_true
        @role_admin.reserved?.should be_true
        @role_mod.reserved?.should be_false
        @role_user.reserved?.should be_false
        @role_defective.reserved?.should be_false
        @role_power_user.reserved?.should be_false
      end
  
      it 'should indicate if is default' do
        @role_system.default?.should be_true
        @role_owner.default?.should be_true
        @role_admin.default?.should be_true
        @role_mod.default?.should be_true
        @role_user.default?.should be_true
        @role_defective.default?.should be_true
        @role_power_user.default?.should be_false
      end
  
      it 'should indicate if is system' do
        @role_system.system?.should be_true
        @role_owner.system?.should be_false
        @role_admin.system?.should be_false
        @role_mod.system?.should be_false
        @role_user.system?.should be_false
        @role_defective.system?.should be_false
        @role_power_user.system?.should be_false
      end
  
      it 'should indicate if is owner' do
        @role_system.owner?.should be_true
        @role_owner.owner?.should be_true
        @role_admin.owner?.should be_false
        @role_mod.owner?.should be_false
        @role_user.owner?.should be_false
        @role_defective.owner?.should be_false
        @role_power_user.owner?.should be_false
      end
  
      it 'should indicate if is admin' do
        @role_system.admin?.should be_true
        @role_owner.admin?.should be_true
        @role_admin.admin?.should be_true
        @role_mod.admin?.should be_false
        @role_user.admin?.should be_false
        @role_defective.admin?.should be_false
        @role_power_user.admin?.should be_false
      end
  
      it 'should indicate if is moderator' do
        @role_system.mod?.should be_false
        @role_owner.mod?.should be_false
        @role_admin.mod?.should be_false
        @role_mod.mod?.should be_true
        @role_user.mod?.should be_false
        @role_defective.mod?.should be_false
        @role_power_user.mod?.should be_false
      end
   
      it 'should indicate if is defective' do
        @role_system.defective?.should be_false
        @role_owner.defective?.should be_false
        @role_admin.defective?.should be_false
        @role_mod.defective?.should be_false
        @role_user.defective?.should be_false
        @role_defective.defective?.should be_true
        @role_power_user.defective?.should be_false
      end  
    end
  end
end  
  
  
  

