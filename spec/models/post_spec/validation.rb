
describe '- models' do 
  
  describe 'Post' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
  
      it 'should check if body is valid' do
        @post.update_with_updater({:body => ''}, @user_poster).should be_false
        @post.errors[:body].should == 'Body required.'
      end
    end
  end
end