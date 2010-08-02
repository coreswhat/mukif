
describe '- models' do 
  
  describe 'Post' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
  
      it 'should be editable only by creator, administrator or moderator' do
        @post.editable_by?(@user_poster).should be_true
        @post.editable_by?(@user_mod).should be_true
        @post.editable_by?(@user_admin).should be_true
        @post.editable_by?(@user).should be_false
      end
    
      it 'should be updated given the valid parameters' do      
        @post.update_with_updater({:body => 'e_body'}, @user_poster)
        @post.reload
    
        @post.body.should == 'e_body'
        @post.edited_at.instance_of?(Time).should be_true
        @post.edited_by.should == @user_poster.username
      end
    end
  end
end