
Mukif.controllers :posts do
 
  before { logged_in_required }
  
  # show
  
    get :show, :with => :id do
      admin_mod_required
      @post = Post.find params[:id]
      render '/posts/show'
    end

  # new
  
    post :create, :map => '/forums/:forum_id/topics/:topic_id/posts/new' do
      t = Topic.find params[:topic_id]
      access_denied if t.posts_locked? && !current_user.admin_mod?
      unless params[:post_body].blank?
        Post.kreate! t, current_user, params[:post_body]        
        flash[:notice] = t('c.posts.create.success')
      else
        flash[:error] = t('c.posts.create.empty')      
      end
      redirect url(:topics, :show, :forum_id => t.forum_id, :id => t, :page => 'last')      
    end 

  # edit
  
    get :edit, :map => '/forums/:forum_id/topics/:topic_id/posts/edit/:id' do
      @post = Post.find params[:id]
      access_denied unless @post.editable_by? current_user
      render '/posts/edit'
    end
    
    put :update, :map => '/forums/:forum_id/topics/:topic_id/posts/edit/:id' do
      @post = Post.find params[:id]
      access_denied unless @post.editable_by? current_user
      unless cancelled?
        if @post.update_with_updater params[:post], current_user
          flash[:notice] = t('c.posts.update.success')
          redirect url(:topics, :show, :forum_id => @post.forum_id, :id => @post.topic_id, :page => params[:page])
        else
          render '/posts/edit'
        end
      else
        redirect url(:topics, :show, :forum_id => @post.forum_id, :id => @post.topic_id, :page => params[:page])   
      end            
    end  

  # quote
  
    get :quote, :with => :id, :provides => :js do
      @post = Post.find params[:id]
      render 'posts/quote'   
    end
end
