
Mukif.controllers :torrents do
  
  before { logged_in_required }

  get :index do
    process_search_keywords 3    
    set_default_order_by 'created_at', true    
    unless params[:s] == '1' # if search form not used
      params[:types] = params[:type_id].blank? ? current_user.default_types_a : [params[:type_id]]
    end

    @torrents = Torrent.search params, current_user, :per_page => settings.c[:page_size][:torrents]
    @torrents.setup_pagination :torrents, :index, settings.c[:browse][:default_desc][:torrents] if @torrents
    
    set_collections_for_torrent
    escape_search_keywords
    render 'torrents/index'    
  end  
  
  # new
  
    get :new, :map => '/upload' do
      @torrent = Torrent.new
      set_collections_for_torrent
      render 'torrents/new' 
    end
    
    post :create, :map => '/upload' do
      @torrent = Torrent.new params[:torrent]
      access_denied if !settings.c[:torrents][:upload_enabled] && !current_user.admin?
      begin
        file_data = get_uploaded_torrent_file_data params[:torrent_file]
        @torrent.user = current_user unless params[:anonymous] == '1'
        if @torrent.parse_and_save(file_data)
          flash[:alert] = t('c.torrents.create.success')
          redirect_to_torrent
        end
      rescue TorrentFileError => e
        logger.debug ":-o torrent file error: #{e.message}"
        @torrent.valid? # check possible additional errors
        @torrent.add_error :torrent_file, e.message, e.args
      end
      set_collections_for_torrent
      render 'torrents/new'
    end
    
  # show
  
    get :show, :with => :id do
      @torrent = Torrent.find_by_id params[:id]
      if torrent_available?
        @torrent.set_bookmarked current_user
        @mapped_files = MappedFile.all_for_torrent @torrent
        @comments = @torrent.paginate_comments params, :per_page => settings.c[:page_size][:torrent_comments]
        @comments.setup_pagination :torrents, :show, nil, 'comments' if @comments
        render 'torrents/show'
      else
        render 'torrents/unavailable'
      end
    end

  # edit
  
    get :edit, :with => :id do
      @torrent = Torrent.find_by_id params[:id]    
      if torrent_available?
        access_denied unless @torrent.editable_by? current_user 
        set_collections_for_torrent
        render 'torrents/edit'
      else
        render 'torrents/unavailable'
      end
    end
    
    put :update, :with => :id do
      @torrent = Torrent.find_by_id params[:id]
      if torrent_available?
        access_denied unless @torrent.editable_by? current_user
        unless cancelled?
          if @torrent.update_with_updater(params[:torrent], current_user, params[:reason])
            flash[:notice] = t('c.torrents.update.success')
            redirect_to_torrent
          else
            logger.debug ':-o torrent not updated'
            set_collections_for_torrent
            render 'torrents/edit'
          end
        else
          redirect_to_torrent
        end
      else
        render 'torrents/unavailable'
      end
    end
    
  # download

    get :download, :with => :id do
      t = Torrent.find_by_id params[:id]
      if torrent_available?(t)
        t.announce_url = tracker_announce_url current_user.passkey
        t.comment = settings.c[:torrents][:file_comment] if settings.c[:torrents][:file_comment]
        file_name = torrent_file_name t, settings.c[:torrents][:file_prefix]
        
        response['Content-Type'] = 'application/x-bittorrent'
        response['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
        response.body = t.out  
      else
        render 'torrents/unavailable'
      end
    end
        
  # bookmark
        
    put :bookmark, :with => :id, :provides => [:js] do
      @torrent = Torrent.find params[:id]
      @torrent.bookmark_unbookmark current_user
      render 'torrents/bookmark'  
    end
    
    get :bookmark, :with => :id, :provides => [:html] do
      t = Torrent.find params[:id]
      t.bookmark_unbookmark current_user
      flash[:notice] = t.bookmarked? ? t('c.torrents.bookmark.bookmarked') : t('c.torrents.bookmark.unbookmarked')
      redirect_to_torrent t
    end   
        
  # reseed request
  
    get :reseed_request, :with => :id do
      @torrent = Torrent.find_by_id params[:id]
      if torrent_available?
        access_denied unless @torrent.eligible_for_reseed_request?
        render 'torrents/reseed_request'        
      else
        render 'torrents/unavailable'
      end
    end     

    post :reseed_request, :with => :id do
      @torrent = Torrent.find_by_id params[:id]
      if torrent_available?
        access_denied unless @torrent.eligible_for_reseed_request?
        unless cancelled?
          cost = settings.c[:torrents][:reseed_request_cost_mb].megabytes
          if current_user.uploaded >= cost
            @torrent.request_reseed current_user, cost, settings.c[:torrents][:reseed_request_notifications]
            flash[:notice] = t('c.torrents.reseed_request.success')              
          else
            flash[:error] = t('c.torrents.reseed_request.insufficient_upload_credit')
          end 
          redirect_to_torrent      
        end
      else
        render 'torrents/unavailable'
      end
    end
        
  # inactivate
  
    get :inactivate, :map => '/torrents/remove/:id' do
      @torrent = Torrent.find_by_id params[:id]
      if torrent_available?
        access_denied if !@torrent.editable_by?(current_user) || !@torrent.active?
        render 'torrents/inactivate'        
      else
        render 'torrents/unavailable'
      end        
    end
    
    put :inactivate, :map => '/torrents/remove/:id' do
      @torrent = Torrent.find_by_id params[:id]
      if torrent_available?
        access_denied if !@torrent.editable_by?(current_user) || !@torrent.active?
        unless cancelled?
          @torrent.inactivate! current_user, params[:reason]
          if current_user.admin_mod?
            flash[:notice] = t('c.torrents.inactivate.success')
            redirect_to_torrent
          else
            Report.kreate! @torrent, current_user, t('c.torrents.inactivate.inactivated_report_tag'), url(:torrents, :show, :id => @torrent)
            session[:notification] = :torrent_inactivated
            redirect url(:notifications, :index)
          end
        else
          redirect_to_torrent
        end
      else
        render 'torrents/unavailable'
      end
    end    
  
  # activate
     
    put :activate, :with => :id do
      admin_mod_required
      t = Torrent.find params[:id]
      t.activate! current_user
      flash[:notice] = t('c.torrents.activate.success')
      redirect_to_torrent t
    end  
    
  # destroy

    get :destroy, :with => :id do
      admin_mod_required
      @torrent = Torrent.find params[:id]
      render 'torrents/destroy'
    end         
  
    delete :destroy, :with => :id do
      admin_mod_required
      @torrent = Torrent.find_by_id params[:id]
      @torrent.destroy_with_notification current_user, params[:reason]
      flash[:notice] = t('c.torrents.destroy.success')
      redirect url(:torrents, :index)
    end         
    
  # switch lock comments
     
    put :switch_lock_comments, :with => :id do
      admin_mod_required
      t = Torrent.find params[:id]
      t.toggle! :comments_locked
      redirect_to_torrent t
    end  

  # user torrents

    get :user_torrents, :map => 'users/:user_id/uploads' do      
      @user = User.find params[:user_id]
      if @user != current_user && !current_user.admin?
        access_denied unless @user.display_uploads?
      end
      set_default_order_by 'created_at', true
      @torrents = Torrent.paginate_user_torrents @user, params, :per_page => settings.c[:page_size][:user_uploads]
      @torrents.setup_pagination :torrents, :user_torrents if @torrents
      render 'torrents/user_torrents'
    end
end
    



