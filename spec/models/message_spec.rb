
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'message_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Message' do

    context '- main class:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_message_variables
      end
    
      it 'should build a new message prepared for view rendering given valid parameters' do
        m = Message.new_for_view(@user_sender, :to => @user_receiver.username)
                           
        m.receiver.should == @user_receiver
      end
    
      it 'should build a new reply message prepared for view rendering given valid parameters' do
        old_message = make_message(@user_sender, @user_sender, @user_receiver, 'old_message_subject', 'old_message_body', Message::INBOX) # message to be replied
    
        m = Message.new_for_view(@user_sender, 
                                 :to => @user_receiver.username, 
                                 :reply => true, 
                                 :message_id => old_message.id)
                           
        m.subject.should == "Re: #{old_message.subject}"
        m.body.should include("#{@user_receiver.username} wrote:")
      end
    
      it 'should build a new forward message prepared for view rendering given valid parameters' do
        old_message = make_message(@user_sender, @user_sender, @user_receiver, 'old_message_subject', 'old_message_body', Message::INBOX) # message to be forwarded
    
        m = Message.new_for_view(@user_sender, 
                                 :forward => true, 
                                 :message_id => old_message.id)
                           
        m.receiver.should be_nil
        m.subject.should == "Fwd: #{old_message.subject}"
        m.body.should include("#{@user_receiver.username} wrote:")
      end
  
      it 'should build a new message prepared for delivery given valid parameters' do
        old_message = make_message(@user_sender, @user_sender, @user_receiver, 'old_message_subject', 'old_message_body', Message::INBOX) # message to be replied
        
        m = Message.new_for_delivery(@user_sender, 
                                     { :subject => 'new_message_subject', :body => 'new_message_body' },
                                     :to => @user_receiver.username, 
                                     :replied_id => old_message.id.to_s)
        m.owner.should == @user_receiver
        m.receiver.should == @user_receiver
        m.sender.should == @user_sender
        m.subject.should == 'new_message_subject'
        m.body.should == 'new_message_body'
        m.replied_id.to_i.should == old_message.id
      end    
        
      it 'should be set as read' do
        m = make_message(@user_receiver, @user_receiver, @user_sender, 'old_message_subject', 'old_message_body', Message::INBOX)
        m.set_as_read!
        m.reload
    
        m.unread?.should be_false
      end
    
      it 'should be moved to another folder' do
        m = make_message(@user_receiver, @user_receiver, @user_sender, 'old_message_subject', 'old_message_body', Message::INBOX)
        m.move_to_folder!(Message::TRASH, @user_receiver)
        m.reload
    
        m.folder.should == Message::TRASH
      end
    end
  end
end