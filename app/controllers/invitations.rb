
Mukif.controllers :invitations do
  
  before { logged_in_required }
  
  get :index do
    ticket_required :inviter
    load_app_params
    @invitations = current_user.invitations
    @invitees = current_user.paginate_invitees params, :per_page => settings.c[:page_size][:users]
    @invitees.setup_pagination :invitations, :index if @invitees    
    render 'invitations/index'
  end
  
  # new
  
    get :new do
      ticket_required :inviter
      load_app_params
      access_denied if !@app_params[:signup_open] && !current_user.staff?
      render 'invitations/new'
    end
    
    post :create do
      ticket_required :inviter
      load_app_params
      access_denied if !@app_params[:signup_open] && !current_user.staff?
      unless cancelled?
        email = params[:email] = escape_html(params[:email])
        if User.valid_email? email
          if User.find_by_email(email) || Invitation.find_by_email(email)
            flash.now[:error] = t('c.invitations.create.email_in_use')
            render 'invitations/new'
          else
            code = Invitation.make_code
            signup_url = absolute_url url(:accounts, :new_with_invitation, :invitation_code => code)
            begin
              deliver :app_mailer, :invitation_email, email, current_user, signup_url, settings.c[:app_name]
            rescue => e
              log_error e
              flash[:error] = t('c.invitations.create.delivery_error')              
            end
            unless flash[:error]
              Invitation.kreate! code, email, current_user 
              flash[:notice] = t('c.invitations.create.success', :email => email)
            end
            redirect url(:invitations, :index)
          end
        else
          flash.now[:error] = t('c.invitations.create.invalid_email')
          render 'invitations/new'
        end
      else
        redirect url(:invitations, :index)
      end      
    end

  # destroy
     
    delete :destroy, :with => :id do
      i = Invitation.find params[:id]
      access_denied if i.user_id != current_user.id
      i.destroy
      flash[:notice] = t('c.invitations.destroy.success')
      redirect url(:invitations, :index)
    end
end

