
describe '- models' do 
  
  describe 'Torrent' do

    context '- reseed_request:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
      
      it 'should charge requester and notify uploader and recent snatchers when asked for a reseed request' do
        make_snatch(@torrent, @user_snatcher)
        make_snatch(@torrent, @user_snatcher_two)
        
        @torrent.snatches_count = 2
        @torrent.save!
        @torrent.reload
              
        @user_reseed_requester.credit!(12345)
        
        @torrent.request_reseed(@user_reseed_requester, 12345, 2)
        @torrent.reload
  
        @user_reseed_requester.uploaded.should == 0
  
        m = find_message_by_receiver_and_subject @user_uploader, 'reseed requested'
        m.should_not be_nil
        m.body.should == "A reseed request for torrent [b][torrent=#{@torrent.id}]#{@torrent.name}[/torrent][/b] was done by [b][user=#{@user_reseed_requester.id}]#{@user_reseed_requester.username}[/user][/b]. Thanks for your help."
        
        m = find_message_by_receiver_and_subject @user_snatcher, 'reseed requested'
        m.should_not be_nil
        m.body.should == "A reseed request for torrent [b][torrent=#{@torrent.id}]#{@torrent.name}[/torrent][/b] was done by [b][user=#{@user_reseed_requester.id}]#{@user_reseed_requester.username}[/user][/b]. Thanks for your help."
  
        m = find_message_by_receiver_and_subject @user_snatcher_two, 'reseed requested'
        m.should_not be_nil
        m.body.should == "A reseed request for torrent [b][torrent=#{@torrent.id}]#{@torrent.name}[/torrent][/b] was done by [b][user=#{@user_reseed_requester.id}]#{@user_reseed_requester.username}[/user][/b]. Thanks for your help."    
      end    
    end
  end
end