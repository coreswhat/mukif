
describe '- models' do 
  
  describe 'Message' do

    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_message_variables
      end
  
      it 'should assign a default subject on creation when subject empty' do
        m = make_message(@user_receiver, @user_receiver, @user_sender, '', nil, Message::INBOX, false)
        m.save!
        m.reload
  
        m.subject.should == 'no subject'
      end
    end
  end
end