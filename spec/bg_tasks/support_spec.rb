
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')
  
describe '- bg_tasks' do 
  
  describe 'BgTasks' do
    
    describe 'Support' do 
      include BgTasks::Support
        
      before(:each) do
        clear_database
      end
      
      it 'should create bg_tasks records from config file' do
        load_bg_tasks
        
        # cleanup_peers
        
          t = find_bg_task_by_name 'cleanup_peers'
          t.should_not be_nil
          t.interval_minutes.should == 50
          
          p = find_bg_task_param_by_bg_task_and_name t, 'peer_max_inactivity_minutes'
          p.should_not be_nil
          p.value.should == 90
          
        # promote_demote
        
          t = find_bg_task_by_name 'promote_demote'
          t.should_not be_nil
          t.interval_minutes.should == 60
          
          p = find_bg_task_param_by_bg_task_and_name t, 'power_user_x_uploader'
          p.should_not be_nil
          p.value['lower'].should == 'power_user'
          p.value['higher'].should == 'uploader'
          p.value['min_uploaded'].should == 100
          p.value['min_ratio'].should == 0.5
      end  
    end
  end
end