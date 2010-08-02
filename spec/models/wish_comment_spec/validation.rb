
describe '- models' do 
  
  describe 'WishComment' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
      end
  
      it 'should check if body is valid' do
        @wish_comment.update_with_updater({:body => ''}, @user_wish_commenter).should be_false
        @wish_comment.errors[:body].should == 'Body required.'
      end
    end
  end
end