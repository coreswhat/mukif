
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'report_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Report' do

    context '- main class:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        load_wish_variables
        load_forum_variables
        
        @user_reporter = make_user('joe-the-reporter', @role_user)
      end
    
      it 'should generate a proper target label' do
        Report.make_target_label(@wish_comment).should == "wish_comment [#{@wish_comment.id}]"
      end
      
      it 'should create an user report' do
        Report.kreate! @user, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "user [#{@user.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end
      
      it 'should create a torrent report' do
        Report.kreate! @torrent, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "torrent [#{@torrent.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end
      
      it 'should create a comment report' do
        Report.kreate! @comment, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "comment [#{@comment.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end 
      
      it 'should create a wish report' do
        Report.kreate! @wish, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "wish [#{@wish.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end 
    
      it 'should create a wish comment report' do
        Report.kreate! @wish_comment, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "wish_comment [#{@wish_comment.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end
      
      it 'should create a topic report' do
        Report.kreate! @topic, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "topic [#{@topic.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end 
      
      it 'should create a post report' do
        Report.kreate! @post, @user_reporter, 'whatever_reason', 'path_to_target'
        find_report_by_reporter_and_target_label(@user_reporter, "post [#{@post.id}]").should_not be_nil
        find_report_by_reason_and_target_path('whatever_reason', 'path_to_target').should_not be_nil
      end
    end 
  end
end  
  

