
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'wish_comment_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'WishComment' do
  
    context '- main class:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
      end
        
      it 'should be created given valid parameters' do
        WishComment.kreate! @wish, @user_wish_commenter, 'n_body'
        c = find_wish_comment_by_body 'n_body'
        c.should_not be_nil
      end
    end
  end
end