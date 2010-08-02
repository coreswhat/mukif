
Mukif.helpers do
  
  # controller
  
    def check_signup_open
      unless @app_params[:signup_open]
        logger.debug ':-) signup is closed'
        flash[:error] = t('h.accounts_helper.check_signup_open.closed')
        return false
      end
      true
    end

    def check_signup_not_blocked
      signup_block = SignupBlock.find_by_ip request.ip
      if signup_block && signup_block.blocked?
        logger.debug ":-) signup temporarily blocked for this ip: #{signup_block.ip}"
        flash[:error] = t('h.accounts_helper.check_signup_not_blocked.blocked')
        return false
      end
      true
    end
    
    def create_signup_block(ip, blocked_until)
      SignupBlock.kreate! ip, blocked_until
    end    
    
    def create_account_recovery(user)
      AccountRecovery.kreate! user
    end
    
    def pre_proccess_invitation
      if params[:invitation_code]
        i = Invitation.find_by_code params[:invitation_code]
        if i
          @user.email = i.email
        else
          @user.add_error(:invitation_code, 'invalid') if @app_params[:signup_by_invitation_only]
        end
      end
    end    
end