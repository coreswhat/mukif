
describe '- models' do 
  
  describe 'WishBounty' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
      
        @user_wish_bounter.credit! 12345
      end
  
      it 'should set its number' do
        @wish.bounties_count = 0
        @wish.save!
        @wish.reload
        
        b = WishBounty.kreate! @wish, @user_wish_bounter, 12345
        
        b.bounty_number.should == 1
      end
  
      it 'should charge bounty amount from the bounter on creation' do
        WishBounty.kreate! @wish, @user_wish_bounter, 12345
        @user_wish_bounter.reload
    
        @user_wish_bounter.uploaded.should == 0
      end
  
      it 'should add amount to wish total bounty on creation' do
        @wish.total_bounty = 0
        @wish.save!
        @wish.reload
    
        WishBounty.kreate! @wish, @user_wish_bounter, 12345
        @wish.reload
    
        @wish.total_bounty.should == 12345
      end
  
      it 'should increment wish bounties counter on creation' do
        @wish.bounties_count = 0
        @wish.save!
        @wish.reload
        
        WishBounty.kreate! @wish, @user_wish_bounter, 12345
        @wish.reload
    
        @wish.bounties_count.should == 1
      end
    
      it 'should refund user if destroyed when not revoked or rewarded' do
        b = WishBounty.kreate! @wish, @user_wish_bounter, 12345
        b.destroy
        @user_wish_bounter.reload
    
        @user_wish_bounter.uploaded.should == 12345
      end
    end
  end
end
