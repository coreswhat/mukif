
Mukif.helpers do

  # controller

    def after_login  # callback from authentication
      current_user.update_attribute(:last_login_at, Time.now)
      session[:adm_menu] = current_user.admin?
      clear_login_attempts
    end   

    def flash_failed_login(login_attempt)
      if login_attempt.blocked?
        flash.now[:error] = t('h.sessions_helper.flash_failed_login.blocked', :hours => settings.c[:login][:block_hours])
      else
        flash.now[:error] = t('h.sessions_helper.flash_failed_login.invalid_login', :remaining => settings.c[:login][:max_attempts] - login_attempt.attempts_count)
      end
    end

    def clear_login_attempts
      LoginAttempt.delete_all_by_ip request.ip
    end    
end