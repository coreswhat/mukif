
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- authorization' do 
  
  describe 'Authorization' do
    
    describe 'Helpers' do 
      include Authorization::Helpers
  
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
        
        @current_user = nil
      end
  
      # mock methods
  
        def current_user
          @current_user ||= @user
        end
        
        def set_current_user(u)
          @current_user = u
        end
  
      it 'should require current user to have ticket' do
        current_user.role.tickets = nil
        current_user.extra_tickets = nil
        current_user.role.save!
        current_user.save!
        current_user.reload    
        
        lambda { ticket_required(:n_ticket) }.should raise_error(Authorization::AccessDeniedError)
        
        current_user.extra_tickets = 'n_extra_ticket'
        current_user.save!
        current_user.reload    
        
        lambda { ticket_required(:n_extra_ticket) }.should_not raise_error(Authorization::AccessDeniedError)
      end
      
      it 'should require current user to have role owner' do     
        lambda { owner_required }.should raise_error(Authorization::AccessDeniedError)
        
        set_current_user @user_owner      
        lambda { owner_required }.should_not raise_error(Authorization::AccessDeniedError)
      end
  
      it 'should require current user to have role admin' do     
        lambda { admin_required }.should raise_error(Authorization::AccessDeniedError)
        
        set_current_user @user_admin      
        lambda { admin_required }.should_not raise_error(Authorization::AccessDeniedError)
      end
    
      it 'should require current user to have role admin or moderator' do     
        lambda { admin_mod_required }.should raise_error(Authorization::AccessDeniedError)
        
        set_current_user @user_admin      
        lambda { admin_mod_required }.should_not raise_error(Authorization::AccessDeniedError)
        
        set_current_user @user_mod      
        lambda { admin_mod_required }.should_not raise_error(Authorization::AccessDeniedError)
      end
    
      it 'should require current user to be staff member' do     
        lambda { staff_required }.should raise_error(Authorization::AccessDeniedError)
        
        @user.add_extra_ticket! :staff
        @user.reload      
        lambda { staff_required }.should_not raise_error(Authorization::AccessDeniedError)
        
        set_current_user @user_admin      
        lambda { staff_required }.should_not raise_error(Authorization::AccessDeniedError)
        
        set_current_user @user_mod      
        lambda { staff_required }.should_not raise_error(Authorization::AccessDeniedError)
      end
  
      it 'should raise access denied error if access denied invoked' do     
        lambda { access_denied }.should raise_error(Authorization::AccessDeniedError)
      end
    end
  end
end


