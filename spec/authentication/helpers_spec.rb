
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- authentication' do 
  
  describe 'Authentication' do
    
    describe 'Helpers' do 
      include Authentication::Helpers
      
      before(:each) do
        clear_database    
        load_default_variables
        
        @session = @request = @response = @redirected_to = nil
      end
  
      # mock classes       
      
        class MockPadrinoSettings 
          def uri_root
            '/'
          end
          
          def remember_me_period
            30.days
          end
          
          def login_path
            '/login'
          end
        end
    
        class MockRequest
          def initialize
            @mock_cookies = {}
          end
          
          def cookies
            @mock_cookies
          end
          
          def set_cookie(name, value)
            @mock_cookies[name] = value # note that value sometimes is a hash 
          end
          
          def path
            '/whatever'
          end
        end
        
        class MockResponse < MockRequest      
        end    
  
      # mock methods
  
        def session
          @session ||= {}
        end
        
        def request
          @request ||= MockRequest.new
        end
        
        def response
          @response ||= MockResponse.new
        end
        
        def settings
          @setting ||= MockPadrinoSettings.new
        end
        
        def redirect(to)
          @redirected_to = to
        end
      
      context '- filters:' do
      
        it 'should redirect to login path if logged in required and not logged in' do
          logged_in_required           
          
          @redirected_to.should == settings.login_path
          session[:return_to].should == request.path
        end
        
        it 'should redirect to uri root if logged out required and not logged out' do
          @user.session_token = 'n_session_token'
          @user.save!
          @user.reload
                
          session[:id], session[:session_token] = @user.id, @user.session_token          
          
          not_logged_in_required
          
          @redirected_to.should == settings.uri_root
        end   
      end
  
      context '- current user:' do
      
        it 'should set current user' do            
          set_current_user @user
          
          current_user.should == @user
        end
      end
            
      context '- authentication:' do
      
        it 'should authenticate from session' do            
          @user.session_token = 'n_session_token'
          @user.save!
          @user.reload
                
          session[:id], session[:session_token] = @user.id, @user.session_token
                
          authenticate_from_session.should == @user
        end
        
        it 'should not authenticate from session if session token invalid' do            
          @user.session_token = 'n_session_token'
          @user.save!
          @user.reload
                
          session[:id], session[:session_token] = @user.id, 'nononono'
          
          authenticate_from_session.should be_nil      
        end    
      
        it 'should authenticate from cookie' do            
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.from_now
          @user.save!
          @user.reload
                      
          request.set_cookie 'remember_token', @user.remember_token
          
          authenticate_from_cookie.should == @user      
        end
        
        it 'should not authenticate from cookie if remember token invalid' do            
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.from_now
          @user.save!
          @user.reload     
                      
          request.set_cookie 'remember_token', 'nononono'
          
          authenticate_from_cookie.should be_nil
        end
        
        it 'should not authenticate from cookie if remember token expired' do            
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.ago
          @user.save!
          @user.reload     
                
          request.set_cookie 'remember_token', @user.remember_token 
          
          authenticate_from_cookie.should be_nil
        end
      end 
      
      context '- login:' do
          
        it 'should log user in and set remember cookie in response' do      
          @user.session_token = nil
          @user.remember_token, @user.remember_token_expires_at = nil, nil
          @user.save!
          @user.reload
                
          login @user, true
          
          @user.reload
          
          current_user.should == @user
          
          @user.session_token.should_not be_nil
          session[:id].should == @user.id
          session[:session_token].should == @user.session_token      
          
          @user.remember_token.should_not be_nil
          @user.remember_token_expires_at.instance_of?(Time).should be_true
          
          response.cookies['remember_token'][:value].should == @user.remember_token 
          response.cookies['remember_token'][:expires].to_s.should == @user.remember_token_expires_at.to_s
        end
      end
      
      context '- logout:' do
      
        it 'should log user out' do
          @user.session_token = 'n_session_token'
          @user.remember_token, @user.remember_token_expires_at = 'n_remember_token', 1.day.from_now
          @user.save!
          @user.reload
          
          session[:id], session[:session_token] = @user.id, @user.session_token            
          request.set_cookie 'remember_token', @user.remember_token
          
          logout
          
          @user.reload
          
          current_user.should be_nil
          
          @user.session_token.should be_nil
          
          @user.remember_token.should be_nil
          @user.remember_token_expires_at.should be_nil
                
          session[:id].should be_nil
          session[:session_token].should be_nil
                
          response.cookies['remember_token'].should be_nil 
        end 
      end
      
      context '- redirect back:' do
      
        it 'should redirect back' do
          session[:return_to] = '/back'
          
          redirect_back_or_default settings.uri_root          
          
          @redirected_to.should == '/back'
          session[:return_to].should be_nil
        end
      end            
    end
  end
end
