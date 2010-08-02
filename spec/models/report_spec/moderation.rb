
describe '- models' do 
  
  describe 'Report' do

    context '- moderation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        
        @user_reporter = make_user('joe-the-reporter', @role_user)
        @report = make_report(@user_reporter)
      end
      
      it 'should be assigned to a user' do
        @report.assign_to! @user_mod
        @report.reload
        @report.handler.should == @user_mod
      end
    
      it 'should be unassigned' do
        @report.assign_to! @user_mod      
        @report.unassign!
        @report.reload
        @report.handler.should be_nil
      end
    end
  end
end