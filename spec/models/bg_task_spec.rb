
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- models' do 
  
  describe 'BgTask' do
  
    context '- main class' do
  
      before(:each) do
        clear_database
        
        class ::BgTask  
          @@task_class_method_invoked = nil
          
          def self.task_class_method_invoked
            @@task_class_method_invoked
          end
          
          def self.my_test_bg_task(params_hash) # method name same as @bg_task name
            @@task_class_method_invoked = 'yes'
          end
                       
          def get_params_hash
            params_hash # temporary access to private method params_hash
          end        
        end  
        
        @bg_task = make_bg_task('my_test_bg_task', 4)    
      end
  
      context '- creation:' do
        
        it 'should be created given a valid yml configuration entry' do
          config = open(File.join(TEST_DATA_DIR, 'bg_tasks_test.yml')) {|f| YAML.load(f) }
          
          config.each do |task_name, task_properties|
            task_properties.symbolize_keys!
      
            t = BgTask.new
            t.name = task_name
            t.interval_minutes = task_properties[:interval_minutes]
      
            task_properties[:params].each do |param_name, param_value|
              t.add_param param_name, param_value
            end
            t.save!
          end
          
          t = find_bg_task_by_name 'test_bg_task'
          t.should_not be_nil
          t.interval_minutes.should == 4
                          
          t.get_params_hash[:test_param_integer].should == 3
          t.get_params_hash[:test_param_array].should == [5, 7]
        end
      end
      
      context '- next execution time expired:' do
        
        it 'should invoke class method with name equals task name when executed' do   
          @bg_task.next_exec_after = 1.minute.ago
          @bg_task.save!
          @bg_task.reload    
          
          @bg_task.exec        
          BgTask.task_class_method_invoked.should == 'yes'
        end    
      
        it 'should be scheduled to future when executed' do
          @bg_task.next_exec_after = 1.minute.ago
          @bg_task.save!
          @bg_task.reload
          
          @bg_task.exec
          @bg_task.reload
      
          @bg_task.next_exec_after.should > Time.now
        end
      end
      
      context '- next execution time empty:' do
      
        it 'should not invoke the task class method when executed' do
          @bg_task.next_exec_after = nil
          @bg_task.save!
          @bg_task.reload
          
          @bg_task.exec
          BgTask.task_class_method_invoked.should_not == 'yes'
        end
      
        it 'should be scheduled to future when executed' do
          @bg_task.next_exec_after = nil
          @bg_task.save!
          @bg_task.reload
          
          @bg_task.exec
          @bg_task.reload
      
          @bg_task.next_exec_after.should > Time.now
        end
      end
  
      context '- next execution time not expired:' do
      
        it 'should not invoke the task class method when executed' do
          @bg_task.next_exec_after = 1.minute.from_now
          @bg_task.save!
          @bg_task.reload
          
          @bg_task.exec        
          BgTask.task_class_method_invoked.should_not == 'yes'
        end
            
        it 'should keep schedule when executed' do
          t = 1.minute.from_now
          @bg_task.next_exec_after = t
          @bg_task.save!
          @bg_task.reload
          
          @bg_task.exec
          @bg_task.reload
          @bg_task.next_exec_after.to_s.should == t.to_s 
        end  
      end
  
      context '- inactive:' do
          
        it 'should not invoke the task class method when executed' do
          @bg_task.active = false
          @bg_task.save!
          @bg_task.reload
          
          @bg_task.exec        
          BgTask.task_class_method_invoked.should_not == 'yes'
        end
      end
    end
  end
end







