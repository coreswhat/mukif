
describe '- models' do 
  
  describe 'Topic' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
      
      it 'should set its number' do
        @forum.topics_count = 0
        @forum.save!
        @forum.reload
        
        t = Topic.create! :forum => @forum, :user => @user, :title => 'n_title', :body => 'n_body'
        t.topic_number.should == 1
      end
  
      it 'should increment forum topics count on creation' do
        @forum.topics_count = 0
        @forum.save!
        @forum.reload
        
        Topic.create! :forum => @forum, :user => @user, :title => 'n_title', :body => 'n_body'
        @forum.reload
              
        @forum.topics_count.should == 1
      end
  
      it 'should decrement forum topics count on destruction' do
        @forum.topics_count = 0
        @forum.save!
        @forum.reload      
        
        t = Topic.create! :forum => @forum, :user => @user, :title => 'n_title', :body => 'n_body'      
        t.destroy
        @forum.reload
              
        @forum.topics_count.should == 0
      end
    end
  end
end