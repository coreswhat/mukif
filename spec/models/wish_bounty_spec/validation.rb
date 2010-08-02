
describe '- models' do 
  
  describe 'WishBounty' do

    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
        
        @user_wish_bounter.credit! 12345
        @wish_bounty = make_wish_bounty @wish, @user_wish_bounter, 12345
      end
  
      it 'should check if amount is valid' do
        @wish_bounty.update_attributes({:amount => ''}).should be_false
        @wish_bounty.errors[:amount].should == 'Amount required.'
      end
    end
  end
end