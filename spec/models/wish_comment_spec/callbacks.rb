
describe '- models' do 
  
  describe 'WishComment' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_wish_variables
      end
      
      it 'should set its number' do
        @wish.comments_count = 0
        @wish.save!
        @wish.reload
        
        c = WishComment.kreate! @wish, @user_wish_commenter, 'n_body'
        
        c.comment_number.should == 1
      end
  
      it 'should increment wish comments count on creation' do
        @wish.comments_count = 0
        @wish.save!
        @wish.reload
        
        WishComment.kreate! @wish, @user_wish_commenter, 'n_body'
        @wish.reload
              
        @wish.comments_count.should == 1
      end
    end
  end
end
