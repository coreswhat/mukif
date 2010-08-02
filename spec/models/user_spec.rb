
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'user_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'User' do
  
    context '- main class:' do
          
      before(:each) do
        clear_database
        load_default_variables
        load_user_variables
      end
      
      it 'should charge upload credit' do
        @user.uploaded = 12345
        @user.save!
        @user.reload
  
        @user.charge! 12345
        @user.reload
        
        @user.uploaded.should == 0
      end
      
      it 'should credit upload credit' do
        @user.uploaded = 0
        @user.save!
        @user.reload
  
        @user.credit! 12345
        @user.reload
        
        @user.uploaded.should == 12345
      end
    end
  end
end  
  
  
  

