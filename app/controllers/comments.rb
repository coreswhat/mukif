
Mukif.controllers :comments do
  
  before { logged_in_required }

  # show
  
    get :show, :with => :id do
      admin_mod_required
      @comment = Comment.find params[:id]
      render 'comments/show'    
    end
    
  # new
  
    post :create, :with => :torrent_id do
      t = Torrent.find params[:torrent_id]
      access_denied if t.comments_locked? && !current_user.admin_mod?
      unless params[:comment_body].blank?
        Comment.kreate! t, current_user, params[:comment_body] 
        flash[:comment_notice] = t('c.comments.create.success')
        redirect url(:torrents, :show, :id => t, :page => 'last') + '#comments' # TODO: change when url with anchor available in padrino
      else
        flash[:comment_error] = t('c.comments.create.empty')
        redirect url(:torrents, :show, :id => t, :page => params[:page]) + '#comments' # TODO: change when url with anchor available in padrino
      end
    end
     
  # edit
  
    get :edit, :map => '/torrents/:torrent_id/comments/edit/:id' do    
      @comment = Comment.find params[:id]
      access_denied unless @comment.editable_by? current_user
      render 'comments/edit' 
    end
    
    put :update, :map => '/torrents/:torrent_id/comments/update/:id' do
      @comment = Comment.find params[:id]
      access_denied unless @comment.editable_by? current_user
      unless cancelled?
        if @comment.update_with_updater params[:comment], current_user
          flash[:comment_notice] = t('c.comments.update.success')          
          url_with_anchor = url(:torrents, :show, :id => @comment.torrent_id, :page => params[:page]) + '#comments' # TODO: change when url with anchor available in padrino           
          redirect url_with_anchor
        else
          render 'comments/edit' 
        end
      else
        url_with_anchor = url(:torrents, :show, :id => @comment.torrent_id, :page => params[:page]) + '#comments' # TODO: change when url with anchor available in padrino
        redirect url_with_anchor
      end
    end

  # quote
  
    get :quote, :with => :id, :provides => :js do
      @comment = Comment.find params[:id]
      render 'comments/quote'   
    end
end

