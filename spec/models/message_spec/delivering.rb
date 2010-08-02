
describe '- models' do 
  
  describe 'Message' do

    context '- delivering:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_message_variables
      end
      
      it 'should be delivered on folder inbox and with unread status' do
        m = make_message(@user_receiver, @user_receiver, @user_sender, 'new_message_subject', 'new_message_body', nil, false)
        m.deliver
  
        delivered = find_message_by_subject_and_owner_and_receiver_and_sender 'new_message_subject', @user_receiver, @user_receiver, @user_sender
        delivered.should_not be_nil
        delivered.folder.should == Message::INBOX
        delivered.unread?.should be_true
      end
  
      it 'should delete replied message on delivery' do
        replied_message = make_message(@user_sender, @user_sender, @user_receiver, 'replied message subject', 'new_message_body', Message::INBOX)
        
        @user_sender.delete_on_reply = true
        @user_sender.save!
  
        m = make_message(@user_receiver, @user_receiver, @user_sender, 'new_message_subject', 'new_message_body', nil, false)
        m.replied_id = replied_message.id      
        m.deliver
  
        r = find_message_by_subject('replied message subject')
        r.folder.should == Message::TRASH
      end
  
      it 'should save sent message on delivery' do
        @user_sender.save_sent = true
        @user_sender.save!
  
        m = make_message(@user_receiver, @user_receiver, @user_sender, 'new_message_subject', 'new_message_body', nil, false)
        m.deliver
  
        s = find_message_by_subject_and_owner_and_receiver_and_folder('new_message_subject', @user_sender, @user_receiver, Message::SENT)
        s.should_not be_nil      
      end
  
      it 'should set receiver new message flag on delivery' do
        @user_receiver.has_new_message = false
        @user_receiver.save!
  
        m = make_message(@user_receiver, @user_receiver, @user_sender, 'new_message_subject', 'system_message_body', nil, false)
        m.deliver
        @user_receiver.reload
  
        @user_receiver.has_new_message?.should be_true
      end
  
      it 'should deliver a system message' do
        Message.deliver_system_message!(@user_receiver, 'system_message_subject', 'system_message_body')
  
        m = find_message_by_receiver_and_sender @user_receiver, @user_system
        m.should_not be_nil
        m.subject.should == 'system_message_subject'
        m.body.should == 'system_message_body'
        m.folder.should == Message::INBOX
        m.should be_unread
      end
    end
  end
end  
  

