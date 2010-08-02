
describe '- models' do 
  
  describe 'Forum' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_forum_variables
      end
    
      it 'should be editable only by an admin' do
        @forum.editable_by?(@user_admin).should be_true
        @forum.editable_by?(@user_mod).should be_false
        @forum.editable_by?(@user).should be_false
      end
    
      it 'should be updated given valid parameters' do
        @forum.update_attributes(:name => 'e_name', :description => 'e_description', :position => '99')
        @forum.reload
        
        @forum.name.should == 'e_name'
        @forum.description.should == 'e_description'
        @forum.position.should == 99
      end
    end
  end
end