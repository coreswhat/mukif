
describe '- models' do 
  
  describe 'Wish' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        load_wish_variables
      end
      
      it 'should check if name is valid' do
        @wish.update_with_updater({:name => ''}, @user_wisher).should be_false
        @wish.errors[:name].should == 'Name required.'
      end
  
      it 'should check if year is valid' do
        @wish.update_with_updater({:year => '999'}, @user_wisher).should be_false
        @wish.errors[:year].should == 'Invalid year.'
      end
      
      it 'should raise error if counters are negative' do
        @wish.total_bounty = -1
        lambda { @wish.save }.should raise_error
      end     
    end
  end
end