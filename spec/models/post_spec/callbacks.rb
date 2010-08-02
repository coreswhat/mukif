
describe '- models' do 
  
  describe 'Post' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
      
      it 'should set its number' do
        @topic.posts_count = 0
        @topic.save!
        @topic.reload
        
        c = Post.kreate! @topic, @user_poster, 'n_body'
        c.post_number.should == 1
      end
  
      it 'should increment topic posts count and set last post info on creation' do
        @topic.posts_count = 0
        @topic.save!
        @topic.reload
        
        Post.kreate! @topic, @user_poster, 'n_body'
        @topic.reload
              
        @topic.posts_count.should == 1
        @topic.last_post_at.instance_of?(Time).should be_true
        @topic.last_post_by.should == @user_poster.username
      end
    end
  end
end
