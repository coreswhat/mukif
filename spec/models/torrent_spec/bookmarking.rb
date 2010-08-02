
describe '- models' do 
  
  describe 'Torrent' do

    context '- bookmarking:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should be bookmarked' do
        @torrent.bookmark_unbookmark(@user)
  
        b = find_bookmark_by_torrent_and_user @torrent, @user 
        b.should_not be_nil
      end
  
      it 'should be unbookmarked' do
        @torrent.bookmark_unbookmark(@user)
        @torrent.bookmark_unbookmark(@user)
  
        b = find_bookmark_by_torrent_and_user @torrent, @user
        b.should be_nil
      end
    end
  end
end