
describe '- models' do 
  
  describe 'Topic' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
      
      it 'should check if name is valid' do
        @topic.update_with_updater({:title => ''}, @user_poster).should be_false
        @topic.errors[:title].should == 'Title required.'
      end
  
      it 'should check if body is valid' do
        @topic.update_with_updater({:body => ''}, @user_poster).should be_false
        @topic.errors[:body].should == 'Body required.'
      end
    end
  end
end