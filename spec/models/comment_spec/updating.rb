
describe '- models' do 
  
  describe 'Comment' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should be editable only by creator, administrator or moderator' do
        @comment.editable_by?(@user_commenter).should be_true
        @comment.editable_by?(@user_mod).should be_true
        @comment.editable_by?(@user_admin).should be_true
        @comment.editable_by?(@user).should be_false
      end
    
      it 'should be updated given the valid parameters' do
        @comment.update_with_updater({:body => 'e_body'}, @user_commenter)
        @comment.reload
        
        @comment.body.should == 'e_body'
        @comment.edited_at.instance_of?(Time).should be_true
        @comment.edited_by.should == @user_commenter.username
      end
    end
  end
end