
describe '- models' do 
  
  describe 'Comment' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should check if body is valid' do
        @comment.update_with_updater({:body => ''}, @user_commenter).should be_false
        @comment.errors[:body].should == 'Body required.'
      end
    end
  end
end