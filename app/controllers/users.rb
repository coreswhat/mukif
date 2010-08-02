
Mukif.controllers :users do
  
  before { logged_in_required }
  
  get :index, :map => '/users' do
    set_default_order_by 'username'

    @users = User.search params, current_user, :per_page => settings.c[:page_size][:users]
    @users.setup_pagination :users, :index, settings.c[:browse][:default_desc][:users] if @users
    
    @roles, @countries= Role.all_for_search, Country.all
    render 'users/index'
  end  
  
  # show
  
    get :show, :with => :id do
      @user = User.find params[:id]
      if @user == current_user && @user.under_ratio_watch? && empty_flash? 
        flash.now[:ratio_watch] = t('c.users.show.ratio_watch', :until => l(@user.ratio_watch_until, :format => :date))
      end
      render 'users/show'
    end

  # new  

    get :new do
      admin_required
      @user = User.new
      set_collections_for_user
      render 'users/new'
    end
    
    post :create do
      admin_required
      @user = User.new params[:user]
      if @user.valid?
        @user.inviter = current_user
        @user.save
        logger.debug ":-) user created. id: #{@user.id}"
        redirect_to_user
      else
        logger.debug ':-o user not created'
        @user.password = @user.password_confirmation = ''
        set_collections_for_user
        render 'users/new'
      end
    end    
        
  # edit  

    get :edit, :with => :id do
      @user = User.find params[:id]
      access_denied unless @user.editable_by? current_user
      set_collections_for_user
      @types = Type.all
      @roles = Role.all_for_user_edition(@user, current_user) if current_user.admin?
      params[:types] = @user.default_types_a
      render 'users/edit'
    end
    
    put :update, :with => :id do
      @user = User.find params[:id]
      access_denied unless @user.editable_by? current_user
      unless cancelled?
        params[:user][:default_types] = params[:types]          
        if @user.update_with_updater(params[:user], current_user, params[:current_password], params[:update_counters] == '1')
          flash[:notice] = t('c.users.update.success')
          redirect_to_user
        else
          logger.debug ':-o user not updated'
          @user.password = @user.password_confirmation = ''
          set_collections_for_user
          @types = Type.all
          @roles = Role.all_for_user_edition(@user, current_user) if current_user.admin?
          render 'users/edit'
        end
      else
        redirect_to_user
      end
    end
    
  # destroy  

    get :destroy, :with => :id do
      admin_required
      @user = User.find params[:id]
      access_denied if !@user.editable_by?(current_user) || @user == current_user
      render 'users/destroy'
    end
    
    delete :destroy, :with => :id do
      admin_required
      @user = User.find params[:id]
      access_denied if !@user.editable_by?(current_user) || @user == current_user
      @user.destroy_with_log(current_user)              
      flash[:notice] = t('c.users.destroy.success')        
      redirect url(:users, :index)
    end     
    
  # edit staff info  

    get :edit_staff_info, :with => :id do
      staff_required
      @user = User.find params[:id]
      render 'users/edit_staff_info'
    end
    
    put :update_staff_info, :with => :id do
      staff_required
      @user = User.find params[:id]
      @user.update_attribute :staff_info, params[:staff_info]
      redirect_to_user
    end    
    
  # reset passkey 

    get :reset_passkey, :with => :id do
      @user = User.find params[:id]
      access_denied if @user != current_user && !current_user.admin?
      render 'users/reset_passkey'
    end
    
    put :reset_passkey, :with => :id do
      @user = User.find params[:id]
      access_denied if @user != current_user && !current_user.admin?
      unless cancelled?
        @user.reset_passkey_with_notification(current_user)
        flash[:notice] = t('c.users.reset_passkey.success')
      end
      redirect_to_user
    end    
        
  # my ...  

    get :my_bookmarks, :map => '/my_bookmarks' do
      @torrents = Torrent.paginate_user_bookmarked_torrents current_user, params, current_user.admin_mod?, :per_page => 20
      @torrents.setup_pagination :users, :my_bookmarks if @torrents
      render 'users/my_bookmarks'
    end
    
    get :my_uploads, :map => '/my_uploads' do
      set_default_order_by 'created_at', true
      @torrents = Torrent.paginate_user_torrents current_user, params, :per_page => settings.c[:page_size][:user_uploads]
      @torrents.setup_pagination :users, :my_uploads, settings.c[:browse][:default_desc][:torrents] if @torrents      
      render 'users/my_uploads'
    end
    
    get :my_wishes, :map => '/my_requests' do
      set_default_order_by 'created_at', true      
      @wishes = Wish.paginate_user_wishes current_user, params, :per_page => settings.c[:page_size][:wishes]
      @wishes.setup_pagination :users, :my_wishes, settings.c[:browse][:default_desc][:wishes] if @wishes
      render 'users/my_wishes'
    end
    
    get :my_stuck_torrents, :map => '/my_stuck_torrents' do
      @torrents = Torrent.paginate_user_stuck_torrents current_user, params, true, :per_page => 20
      @torrents.setup_pagination :users, :my_stuck_torrents if @torrents
      render 'users/my_stuck_torrents'
    end
end