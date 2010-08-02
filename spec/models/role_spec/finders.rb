
describe '- models' do 
  
  describe 'Role' do

    context '- finders:' do
      
      before(:each) do
        clear_database
        load_default_variables
      end
      
      it 'should retrieve a list of roles to be used in search forms' do
        a = Role.all_for_search
        a.should_not include(@role_system)
      end
    
      it 'should retrieve limited lists of roles for user edition' do
    
        a = Role.all_for_user_edition(@user, @user_system)
        a.should_not include(@role_system)
        a.should include(@role_owner)
        a.should include(@role_admin)
        a.should include(@role_mod)
        a.should include(@role_user)      
        a.should include(@role_defective)
        a.should include(@role_power_user)
    
        a = Role.all_for_user_edition(@user, @user_owner)
        a.should_not include(@role_system)
        a.should_not include(@role_owner)
        a.should include(@role_admin)
        a.should include(@role_mod)
        a.should include(@role_user)
        a.should include(@role_defective)
        a.should include(@role_power_user)
        
        a = Role.all_for_user_edition(@user, @user_admin)
        a.should_not include(@role_admin)
        a.should_not include(@role_owner)
        a.should_not include(@role_system)
        a.should include(@role_mod)
        a.should include(@role_user)
        a.should include(@role_defective)
        a.should include(@role_power_user)
      end
      
      it 'should retrieve only own role as list of roles for user edition if user editing itself' do
        a = Role.all_for_user_edition(@user_admin, @user_admin)
        a.size.should == 1
        a.should include(@role_admin)
    
        a = Role.all_for_user_edition(@user_owner, @user_owner)
        a.size.should == 1
        a.should include(@role_owner)
    
        a = Role.all_for_user_edition(@user_system, @user_system)
        a.size.should == 1
        a.should include(@role_system)
      end
    end
  end
end