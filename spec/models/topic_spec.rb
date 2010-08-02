
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'topic_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Topic' do

    context '- main class:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
        
      it 'should be created given valid parameters' do
        @forum.topics_count = 0
        @forum.save!
        @forum.reload
        
        t = Topic.new :title => 'n_title', :body => 'n_body'
        t.forum, t.user = @forum, @user
        t.save!
        t.reload
        
        t.title.should == 'n_title'
        t.body.should == 'n_body'      
        t.last_post_at.instance_of?(Time).should be_true
      end
    end
  end
end
