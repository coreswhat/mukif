
Mukif.controllers :accounts do
  
  layout :public
  
  before { not_logged_in_required }

  # new
      
    get :new, :map => '/signup' do
      load_app_params
      if check_signup_open && check_signup_not_blocked
        @user = User.new
        render 'accounts/new'
      else
        redirect url(:sessions, :new)
      end 
    end
    
    get :new_with_invitation, :map => '/signup/:invitation_code' do
      load_app_params
      if check_signup_open && check_signup_not_blocked
        @user = User.new
        pre_proccess_invitation
        render 'accounts/new'
      else
        redirect url(:sessions, :new)
      end 
    end
    
    post :create, :map => '/signup' do
      load_app_params
      if check_signup_open && check_signup_not_blocked
        @user = User.new params[:user]
        if @user.save_new_with_invitation params[:invitation_code], @app_params[:signup_by_invitation_only]
          create_signup_block request.ip, 1.day.from_now
          login @user
          redirect settings.uri_root
        else
          logger.debug ':-o user data invalid'
          @user.password = @user.password_confirmation = ''
          render 'accounts/new'
        end
      else
        redirect url(:sessions, :new)
      end
    end
    
  # recovery
  
    get :recovery, :map => '/forgotten_password' do
      render 'accounts/recovery'
    end
    
    post :recovery, :map => '/forgotten_password' do
      params[:email] = escape_html params[:email]
      u = User.find_by_email params[:email]
      if u && u.active?
        account_recovery = create_account_recovery u
        reset_password_url = absolute_url url(:accounts, :reset_password, :recovery_code => account_recovery.code)
        begin          
          deliver :app_mailer, :account_recovery_email, u.email, reset_password_url                      
        rescue => e
          log_error e
          account_recovery.destroy
          flash[:error] = t('c.accounts.recovery.delivery_error')          
        end        
        flash[:notice] = t('c.accounts.recovery.success', :email => params[:email]) unless flash[:error]          
        redirect url(:sessions, :new)
      else        
        flash.now[:error] = t('c.accounts.recovery.invalid_email')
        render 'accounts/recovery'
      end
    end
    
  # reset password
  
    get :reset_password, :map => '/reset_password/:recovery_code' do
      account_recovery = AccountRecovery.find_by_code params[:recovery_code]
      if account_recovery
        @user = account_recovery.user
        render '/accounts/reset_password'
      else
        logger.debug ':-o invalid recovery code'
        flash[:error] = t('c.accounts.reset_password.invalid_code')
        redirect url(:sessions, :new)
      end      
    end
    
    put :reset_password, :map => '/reset_password/:recovery_code' do
      account_recovery = AccountRecovery.find_by_code params[:recovery_code]
      if account_recovery
        @user = account_recovery.user
        if @user.reset_password(params[:password], params[:password_confirmation])
          logger.debug ':-) user password changed'
          account_recovery.destroy
          clear_login_attempts # sessions helper
          flash[:notice] = t('c.accounts.reset_password.success')
          redirect url(:sessions, :new, :username => @user.username)
        else
          logger.debug ':-o user password not reset'
          render '/accounts/reset_password'
        end
      else
        logger.debug ':-o invalid recovery code'
        flash[:error] = t('c.accounts.reset_password.invalid_code')
        redirect url(:sessions, :new)       
      end
    end
end



