
Mukif.controllers :wish_comments do
  
  before { logged_in_required }

  # show
    
    get :show, :with => :id do
      admin_mod_required
      @wish_comment = WishComment.find params[:id]
      render 'wish_comments/show'    
    end

  # new
  
    post :create do
      w = Wish.find params[:wish_id]
      access_denied if w.comments_locked? && !current_user.admin_mod?
      unless params[:wish_comment_body].blank?
        WishComment.kreate! w, current_user, params[:wish_comment_body]
        flash[:wish_comment_notice] = t('c.wish_comments.create.success')       
        redirect url(:wishes, :show, :id => w, :page => 'last') + '#comments' # TODO: change when url with anchor available in padrino
      else
        flash[:wish_comment_error] = t('c.wish_comments.create.empty')       
        redirect url(:wishes, :show, :id => w, :page => params[:page]) + '#comments' # TODO: change when url with anchor available in padrino
      end      
    end

  # edit
  
    get :edit, :map => '/wishes/:wish_id/comments/edit/:id' do    
      @wish_comment = WishComment.find params[:id]
      access_denied unless @wish_comment.editable_by? current_user
      render 'wish_comments/edit' 
    end
    
    put :update, :map => '/wishes/:wish_id/comments/edit/:id' do
      @wish_comment = WishComment.find params[:id]
      access_denied unless @wish_comment.editable_by? current_user
      unless cancelled?
        if @wish_comment.update_with_updater params[:wish_comment], current_user
          flash[:wish_comment_notice] = t('c.wish_comments.update.success')
          url_with_anchor = url(:wishes, :show, :id => @wish_comment.wish_id, :page => params[:page]) + '#comments' # TODO: change when url with anchor available in padrino                   
          redirect url_with_anchor
        else
          render 'wish_comments/edit' 
        end
      else
        url_with_anchor = url(:wishes, :show, :id => @wish_comment.wish_id, :page => params[:page]) + '#comments'  # TODO: change when url with anchor available in padrino                    
        redirect url_with_anchor
      end
    end  

  # quote
  
    get :quote, :with => :id, :provides => :js do
      @wish_comment = WishComment.find params[:id]
      render 'wish_comments/quote'   
    end
end

