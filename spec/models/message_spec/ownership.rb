
describe '- models' do 
  
  describe 'Message' do

    context '- ownership:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_message_variables
      end
    
      it 'should ensure ownership' do
        m = make_message(@user_receiver, @user_receiver, @user_sender, nil, nil, nil, false)
        m.deliver
  
        lambda { m.ensure_ownership(@user) }.should raise_error(Message::NotOwnerError)
        lambda { m.ensure_ownership(@user_receiver) }.should_not raise_error(Message::NotOwnerError)
      end
    end
  end
end