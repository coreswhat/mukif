
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- models' do 
  
  describe 'LoginAttempt' do

    context '- main class:' do
  
      before(:each) do
        clear_database
        load_default_variables
        
        @login_attempt = make_login_attempt('0.0.0.0')
      end
    
      it 'should be blocked if block until date is not expired' do
        @login_attempt.blocked?.should be_false
    
        @login_attempt.blocked_until = 1.hour.from_now
        @login_attempt.save!
        @login_attempt.reload
        
        @login_attempt.blocked?.should be_true
      end
    
      it 'should increment but not block if max attempts not reached' do
        @login_attempt.attempts_count = 1
        @login_attempt.save!
        @login_attempt.reload
        
        @login_attempt.increment_or_block!(5, 1)
        @login_attempt.reload
    
        @login_attempt.attempts_count.should == 2
        @login_attempt.blocked?.should be_false
      end
    
      it 'should block if max attempts reached' do
        @login_attempt.blocked_until = nil
        @login_attempt.attempts_count = 4
        @login_attempt.save!
        @login_attempt.reload
        
        @login_attempt.increment_or_block!(5, 1)
        @login_attempt.reload
    
        @login_attempt.blocked?.should be_true
        @login_attempt.attempts_count.should == 0
        @login_attempt.blocked_until.instance_of?(Time).should be_true
      end
    end
  end
end