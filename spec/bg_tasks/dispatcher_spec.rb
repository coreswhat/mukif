
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- bg_tasks' do 
  
  describe 'BgTasks' do
    
    describe 'Dispatcher' do 
      include BgTasks::Support
        
      before(:each) do
        clear_database
        load_default_variables
      end
      
      it 'should execute the bg_tasks' do      
        load_bg_tasks
        
        cleanup_peers = find_bg_task_by_name 'cleanup_peers'
        cleanup_peers.next_exec_after = 1.minute.ago
        cleanup_peers.save!
        
        promote_demote = find_bg_task_by_name 'promote_demote'
        promote_demote.next_exec_after = 1.minute.ago
        promote_demote.save!
        
        BgTasks::Dispatcher.exec
        
        l = find_bg_task_log_by_bg_task_name 'dispatcher'
        l.should_not be_nil
        
        cleanup_peers.reload
        cleanup_peers.next_exec_after.should > Time.now
        l = find_bg_task_log_by_bg_task_name 'cleanup_peers'
        l.should_not be_nil
        
        promote_demote.reload
        promote_demote.next_exec_after.should > Time.now
        l = find_bg_task_log_by_bg_task_name 'promote_demote'
        l.should_not be_nil      
      end        
    end
  end
end      