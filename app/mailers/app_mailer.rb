
Mukif.mailer :app_mailer do
   
  email :invitation_email do |email, inviter, signup_url, site_name|
    to      email
    subject I18n.t('mailer.app_mailer.invitation_email.subject')
    locals  :inviter => inviter, :signup_url => signup_url, :site_name => site_name 
    render  'app_mailer/invitation'
  end
  
  email :account_recovery_email do |email, reset_password_url|
    to       email
    subject  I18n.t('mailer.app_mailer.account_recovery_email.subject')    
    locals   :reset_password_url => reset_password_url
    render   'app_mailer/account_recovery'
  end  
end

