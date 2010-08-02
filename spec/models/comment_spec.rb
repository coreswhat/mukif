
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'comment_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Comment' do
  
    context '- main class:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
        
      it 'should be created given valid parameters' do      
        Comment.kreate! @torrent, @user_commenter, 'n_body'
        c = find_comment_by_body 'n_body'
        c.should_not be_nil 
      end
    end
  end
end




