
describe '- models' do 
  
  describe 'Topic' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
        
      it 'should be editable only by creator, administrator or moderator' do
        @topic.editable_by?(@user_poster).should be_true
        @topic.editable_by?(@user_mod).should be_true
        @topic.editable_by?(@user_admin).should be_true
        @topic.editable_by?(@user).should be_false
      end
    
      it 'should be updated given valid parameters' do
        params = {:title => 'e_title', :body => 'e_body'}
         
        @topic.update_with_updater(params, @user_poster)
        @topic.reload
        
        @topic.title.should == 'e_title'
        @topic.body.should == 'e_body'
        @topic.edited_at.instance_of?(Time).should be_true
        @topic.edited_by.should == @user_poster.username
      end
    end
  end
end