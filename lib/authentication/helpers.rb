
module Authentication
  
  module Helpers
   
    # filters
    
      def logged_in_required
        logger.debug ':-) authentication.helpers.logged_in_required'
        if logged_in?
          logger.debug ":-) user logged in: #{current_user.username}"
          after_logged_in_required
        else
          logger.debug ':-o user not logged in, redirecting to login page'
          store_location
          redirect settings.login_path || '/login'
        end
      end
      
      def not_logged_in_required
        logger.debug ':-) authentication.helpers.not_logged_in_required'
        redirect (settings.uri_root || '/') if logged_in?
      end
        
      def logged_in?
        current_user != nil
      end

    # current user    
  
      def current_user
        @current_user ||= (authenticate_from_session || authenticate_from_cookie)
      end
    
      def set_current_user(u)
        @current_user = u
      end
       
    # authentication
    
      def authenticate_from_session
        logger.debug ':-) authentication.helpers.authenticate_from_session'
        User.authenticate_by_session_token session[:id], session[:session_token]
      end
    
      def authenticate_from_cookie
        logger.debug ':-) authentication.helpers.authenticate_from_cookie'
        User.authenticate_by_remember_token request.cookies['remember_token']
      end
            
    # login

      def login(u = nil, remember_me = false)
        set_current_user u 
        
        u.reset_session_token!   
        set_session
        
        if remember_me
          u.remember_me_for(settings.remember_me_period || 30.days)
          send_remember_cookie 
        end
        after_login
      end
  
      def set_session
        session[:id], session[:session_token] = current_user.id, current_user.session_token  
      end
  
      def send_remember_cookie        
        response.set_cookie('remember_token',
                            :path => (settings.uri_root || '/'),  
                            :value => current_user.remember_token,
                            :expires => current_user.remember_token_expires_at)
      end 
        
    # logout
      
      def logout
        if current_user
          current_user.clear_session_token!
          current_user.clear_remember_token!
          set_current_user nil
        end
        clear_session!
        clear_remember_cookie!
      end
    
      def clear_session!      
        session[:id], session[:session_token] = nil, nil
      end
    
      def clear_remember_cookie!
        response.set_cookie('remember_token', nil) if request.cookies['remember_token']
      end
    
    # redirect back
     
      def store_location
        session[:return_to] = request.path
      end
    
      def redirect_back_or_default(default)
        return_to, session[:return_to] = session[:return_to], nil
        redirect return_to || default
      end
    
    # callbacks
    
      def after_logged_in_required
        # called by logged_in_required, overwrite if needed
      end
      
      def after_login
        # called by login, overwrite if needed
      end
  end
end



