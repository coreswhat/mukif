
describe '- models' do 
  
  describe 'Torrent' do

    context '- moderation:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should be inactivated by uploader' do
        @torrent.inactivate!(@user_uploader, '')
        @torrent.reload
        
        @torrent.should_not be_active
      end
              
      it 'should be inactivated by moderator and notify uploader' do
        reason = 'whatever_reason'
        @torrent.inactivate!(@user_mod, reason)
        @torrent.reload
        
        @torrent.active.should be_false
        
        m = find_message_by_receiver_and_subject @torrent.user, 'torrent inactivated'
        m.should_not be_nil
        m.body.should == "Your torrent [b]#{@torrent.name}[/b] was temporarily inactivated by [b][user=#{@user_mod.id}]#{@user_mod.username}[/user][/b] (#{reason})."
      end
  
      it 'should be activated by moderator and notify uploader' do
        @torrent.inactivate!(@user_mod, 'whatever_reason')
        @torrent.reload
        
        @torrent.activate!(@user_mod)
        @torrent.reload
  
        @torrent.active.should be_true
  
        m = find_message_by_receiver_and_subject @torrent.user, 'torrent activated'
        m.should_not be_nil
        m.body.should == "Your torrent [b][torrent=#{@torrent.id}]#{@torrent.name}[/torrent][/b] was activated by [b][user=#{@user_mod.id}]#{@user_mod.username}[/user][/b]."
      end
  
      it 'should be destroyed by moderator and notify uploader' do
        reason = 'whatever_reason'
        @torrent.destroy_with_notification(@user_mod, reason)
  
        t = find_torrent_by_name @torrent.name
        t.should be_nil
  
        m = find_message_by_receiver_and_subject @torrent.user, 'torrent deleted'
        m.should_not be_nil
        m.body.should == "Your torrent [b]#{@torrent.name}[/b] was deleted by [b][user=#{@user_mod.id}]#{@user_mod.username}[/user][/b] (#{reason})."
      end    
    end   
  end
end