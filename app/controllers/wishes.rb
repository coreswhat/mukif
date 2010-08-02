
Mukif.controllers :wishes do
  
  before { logged_in_required }
  # efore_filter :admin_mod_required, :only => [:switch_lock_comments, :approve, :reject]
  
  get :index do
    process_search_keywords 3    
    set_default_order_by 'created_at', true

    @wishes = Wish.search params, :per_page => settings.c[:page_size][:wishes]
    @wishes.setup_pagination :wishes, :index, settings.c[:browse][:default_desc][:wishes] if @wishes    
    
    set_collections_for_wish
    escape_search_keywords    
    render 'wishes/index'
  end 
  
  # new
  
    get :new do
      ticket_required :wisher
      @wish = Wish.new    
      set_collections_for_wish
      render 'wishes/new'
    end
    
    post :create do
      ticket_required :wisher
      @wish = Wish.new params[:wish]
      @wish.user = current_user      
      if @wish.save
        flash[:notice] = t('c.wishes.create.success')
        redirect_to_wish
      else
        set_collections_for_wish
        render 'wishes/new'
      end
    end

  # show
  
    get :show, :with => :id do
      @wish = Wish.find params[:id]
      @wish_comments = @wish.paginate_comments params, :per_page => settings.c[:page_size][:torrent_comments]
      @wish_comments.setup_pagination :wishes, :show, nil, 'comments' if @wish_comments      
      render 'wishes/show'
    end    

  # edit

    get :edit, :with => :id do
      @wish = Wish.find params[:id]
      access_denied unless @wish.editable_by? current_user
      set_collections_for_wish
      render 'wishes/edit'
    end
    
    put :update, :with => :id do
      @wish = Wish.find params[:id]
      access_denied unless @wish.editable_by? current_user
      unless cancelled?
        if @wish.update_with_updater(params[:wish], current_user)
          flash[:notice] = t('c.wishes.update.success')
          redirect_to_wish
        else
          logger.debug ':-o wish not updated'
          set_collections_for_wish
          render 'wishes/edit'
        end
      else
        redirect_to_wish
      end   
    end

  # destroy

    get :destroy, :map => '/wishes/remove/:id' do
      @wish = Wish.find params[:id]
      access_denied unless @wish.editable_by? current_user
      render 'wishes/destroy'
    end         
  
    delete :destroy, :map => '/wishes/remove/:id' do
      @wish = Wish.find params[:id]
      access_denied unless @wish.editable_by? current_user
      unless cancelled?
        @wish.destroy_with_notification current_user, params[:reason]
        flash[:notice] = t('c.wishes.destroy.success')
        redirect url(:wishes, :index)
      else
        redirect_to_wish
      end
    end  

  # fill
  
    get :fill, :with => :id do
      @wish = Wish.find params[:id]
      access_denied if !@wish.open? || @wish.user == current_user
      render 'wishes/fill'
    end
    
    put :fill, :with => :id do
      @wish = Wish.find params[:id]
      access_denied if !@wish.open? || @wish.user == current_user
      unless cancelled?
        t = Torrent.find_by_info_hash_hex params[:info_hash]
        flash.now[:error] = case
          when t.blank?
            t('c.wishes.fill.info_hash_invalid')
          when Wish.torrent_taken?(t)
            t('c.wishes.fill.torrent_taken')
          when t.user != current_user
            t('c.wishes.fill.not_torrent_uploader')
        end
        unless flash[:error]
          @wish.fill! t
          Report.kreate! @wish, current_user, t('c.wishes.fill.report_tag'), url(:wishes, :show, :id => @wish)
          flash[:notice] = t('c.wishes.fill.success')
          redirect_to_wish
        else          
          render 'wishes/fill'
        end
      else
        redirect_to_wish
      end
    end

  # approve filling
    
    put :approve, :with => :id do 
      admin_mod_required
      w = Wish.find params[:id]
      w.approve! current_user
      flash[:notice] = t('c.wishes.approve.success')
      redirect_to_wish w
    end

  # reject filling
 
    get :reject, :with => :id do
      admin_mod_required
      @wish = Wish.find params[:id]
      render 'wishes/reject'
    end

    put :reject, :with => :id do
      admin_mod_required
      w = Wish.find params[:id]
      w.reject! current_user, params[:reason]
      flash[:notice] = t('c.wishes.reject.success')
      redirect_to_wish w
    end
    
  # switch_lock_comments
     
    put :switch_lock_comments, :with => :id do
      admin_mod_required
      w = Wish.find params[:id]
      w.toggle! :comments_locked
      redirect_to_wish w
    end
end

  
