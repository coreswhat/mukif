
Mukif.controllers :sessions do

  layout :public

  # new
  
    get :new, :map => '/login' do
      not_logged_in_required
      load_app_params   
      render '/sessions/new'
    end
  
    post :create, :map => '/login' do
      not_logged_in_required
      login_attempt = LoginAttempt.find_or_new(request.ip)
      if login_attempt.blocked?
        logger.debug ":-) login is temporarily blocked for this ip: #{login_attempt.ip}"
        flash[:error] = t('c.sessions.create.temporarily_blocked') unless flash[:notice]
        redirect url(:sessions, :new)        
      else
        u = User.authenticate params[:username], params[:password]
        if u
          logger.debug ':-) user authenticated'
          if u.active?
            logger.debug ':-) user active'
            login u, params[:remember_me] == '1'
            redirect_back_or_default settings.uri_root
          else
            logger.debug ':-o user not active'
            flash[:error] = t('c.sessions.create.account_disabled')
            redirect url(:sessions, :new)
          end
        else
          logger.debug ':-o user not authenticated'
          login_attempt.increment_or_block!(settings.c[:login][:max_attempts], settings.c[:login][:block_hours])
          flash_failed_login login_attempt
          load_app_params
          render '/sessions/new'
        end
      end            
    end

  # destroy
       
    delete :destroy, :map => '/logout' do
      logged_in_required
      logout
      redirect url(:sessions, :new)
    end
end