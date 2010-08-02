
describe '- models' do 
  
  describe 'Wish' do

    context '- filling:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        load_wish_variables
      end      
    
      # filling
    
        it 'should be fillable with a torrent and remain pending until moderation approval or rejection' do
          @wish.fill! @torrent
          @wish.reload
    
          @wish.open?.should be_false
          @wish.pending?.should be_true
          @wish.torrent.should == @torrent
          @wish.filler.should == @torrent.user
          @wish.filled_at.instance_of?(Time).should be_true
        end
        
        it 'should raise an exception if filled when not open' do
          @wish.fill! @torrent
          @wish.reload
          
          lambda { @wish.fill! @torrent_two }.should raise_error      
        end   
        
        it 'should raise an exception if torrent already used to fill another wish' do
          @wish.fill! @torrent
          @wish.reload
          
          lambda { @wish_two.fill! @torrent }.should raise_error      
        end
    
      # filling moderation
      
        it 'should have its filling approved, credit its bounty to filler and notify users' do
          filler_upload_credit = @torrent.user.uploaded
    
          @user_wish_bounter.credit!(12345)
          make_wish_bounty @wish, @user_wish_bounter, 12345
          @wish.reload
          @user_wish_bounter_two.credit!(54321)
          make_wish_bounty @wish, @user_wish_bounter_two, 54321
          @wish.reload
    
          @wish.fill! @torrent
          @wish.reload
    
          @wish.approve! @user_mod
          @wish.reload
          @torrent.user.reload
    
          # wish filling approved?
          @wish.pending?.should be_false
          @wish.filled?.should be_true
    
          # bounty credited to filler?
          @torrent.user.uploaded.should == filler_upload_credit + @wish.total_bounty
    
          # filler notified?
          m = find_message_by_receiver_and_subject @torrent.user, 'request filling approved'
          m.should_not be_nil
          m.body.should == "Your filling for request [b][wish=#{@wish.id}]#{@wish.name}[/wish][/b] was approved. The request bounty was added to your upload credit."
    
          # wisher notified?
          m = find_message_by_receiver_and_subject @user_wisher, 'your request has been filled'
          m.should_not be_nil
          m.body.should == "Your request [b][wish=#{@wish.id}]#{@wish.name}[/wish][/b] has been filled."
    
          # bounter notified?
          m = find_message_by_receiver_and_subject @user_wish_bounter, 'request filled'
          m.should_not be_nil
          m.body.should == "Request [b][wish=#{@wish.id}]#{@wish.name}[/wish][/b] has been filled."
    
          # bounter two notified?
          m = find_message_by_receiver_and_subject @user_wish_bounter_two, 'request filled'
          m.should_not be_nil
          m.body.should == "Request [b][wish=#{@wish.id}]#{@wish.name}[/wish][/b] has been filled."
        end
    
        it 'should have its filling rejected and notify filler' do
          @wish.fill! @torrent
          @wish.reload
    
          reason = 'whatever_reason'
          @wish.reject! @user_mod, reason
          @wish.reload
    
          @wish.pending?.should be_false
          @wish.filled?.should be_false
          @wish.torrent.should be_nil
          @wish.filler.should be_nil
          @wish.filled_at.should be_nil
    
          # filler notified?
          m = find_message_by_receiver_and_subject @torrent.user, 'request filling rejected'
          m.should_not be_nil
          m.body.should == "Your filling for request [b][wish=#{@wish.id}]#{@wish.name}[/wish][/b] was rejected by [b][user=#{@user_mod.id}]#{@user_mod.username}[/user][/b] (#{reason})."
        end
    end
  end
end