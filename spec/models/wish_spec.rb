
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'wish_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Wish' do

    context '- main class:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        load_wish_variables
      end
    
      # status
    
        it 'should be open if not pending or filled' do
          @wish.pending = false
          @wish.filled = false
          @wish.should be_open
    
          @wish.pending = true
          @wish.should_not be_open
    
          @wish.pending = false
          @wish.filled = true
          @wish.should_not be_open
        end  
    
      # deletion
    
        it 'should notify its destruction when destroyed by a moderator' do 
          reason = 'whatever_reason'
          
          @wish.destroy_with_notification @user_mod, reason
    
          # wish deleted?
          find_wish_by_name(@wish.name).should be_nil
    
          # wisher notified?
          m = find_message_by_receiver_and_subject @user_wisher, 'request removed'
          m.should_not be_nil
          m.body.should == "Your request [b]#{@wish.name}[/b] was removed by [b][user=#{@user_mod.id}]#{@user_mod.username}[/user][/b] (#{reason})."
        end
    end
  end
end
