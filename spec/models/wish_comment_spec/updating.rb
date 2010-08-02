
describe '- models' do 
  
  describe 'WishComment' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
      end
  
      it 'should be editable only by creator, administrator or moderator' do
        @wish_comment.editable_by?(@user_wish_commenter).should be_true
        @wish_comment.editable_by?(@user_mod).should be_true
        @wish_comment.editable_by?(@user_admin).should be_true
        @wish_comment.editable_by?(@user).should be_false
      end
      
      it 'should be updated given the valid parameters' do
        @wish_comment.update_with_updater({:body => 'e_body'}, @user_wish_commenter)
        @wish_comment.reload
    
        @wish_comment.body.should == 'e_body'
        @wish_comment.edited_at.instance_of?(Time).should be_true
        @wish_comment.edited_by.should == @user_wish_commenter.username
      end
    end
  end
end