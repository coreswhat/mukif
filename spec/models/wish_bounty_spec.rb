
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'wish_bounty_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'WishBounty' do

    context '- main class:' do
    
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
    
        @user_wish_bounter.credit! 12345
      end
      
      it 'should be created given valid parameters' do
        WishBounty.kreate! @wish, @user_wish_bounter, 12345
        b = find_wish_bounty_by_wish_and_user_and_amount @wish, @user_wish_bounter, 12345
        b.should_not be_nil
      end
    
      it 'should refund user if revoked' do
        b = make_wish_bounty(@wish, @user_wish_bounter, 12345)
    
        b.revoke!
        @user_wish_bounter.reload
    
        @user_wish_bounter.uploaded.should == 12345
      end
    
      it 'should subtract amount from wish total bounty if revoked' do
        b = make_wish_bounty(@wish, @user_wish_bounter, 12345)
        @wish.reload
        
        total_bounty = @wish.total_bounty
    
        b.revoke!
        @wish.reload
    
        @wish.total_bounty.should == total_bounty - 12345
      end
    end
  end
end
