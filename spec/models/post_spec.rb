
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'post_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Post' do
  
    context '- main class:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
        
      it 'should be created given valid parameters' do      
        Post.kreate! @topic, @user_poster, 'n_body'      
        p = find_post_by_body 'n_body'
        p.should_not be_nil
      end
    end
  end
end  


