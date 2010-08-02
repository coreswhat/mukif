
describe '- models' do 
  
  describe 'Comment' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
      
      it 'should set its number' do
        @torrent.comments_count = 0
        @torrent.save!
        @torrent.reload
        
        c = Comment.kreate! @torrent, @user_commenter, 'n_body'
        
        c.comment_number.should == 1
      end
  
      it 'should increment torrent comments count on creation' do
        @torrent.comments_count = 0
        @torrent.save!
        @torrent.reload
        
        Comment.kreate! @torrent, @user_commenter, 'n_body'
        @torrent.reload
              
        @torrent.comments_count.should == 1
      end
    end
  end
end
