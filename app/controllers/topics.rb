
Mukif.controllers :topics do
  
  before { logged_in_required }
  
  # show
  
    get :show, :map => '/forums/:forum_id/topics/show/:id' do
      @topic = Topic.find params[:id]
      @posts = @topic.paginate_posts params, :per_page => settings.c[:page_size][:forum_posts]
      @posts.setup_pagination :topics, :show if @posts      
      render 'topics/show'
    end 

  # new  

    get :new, :map => '/forums/:forum_id/topics/new' do
      @forum = Forum.find params[:forum_id]
      access_denied if @forum.topics_locked? && !current_user.admin_mod?
      @topic = Topic.new
      render 'topics/new'
    end
    
    post :create, :map => '/forums/:forum_id/topics/new' do
      @forum = Forum.find params[:forum_id]
      access_denied if @forum.topics_locked? && !current_user.admin_mod?
      unless cancelled?
        @topic = Topic.new params[:topic]
        @topic.forum, @topic.user = @forum, current_user
        if @topic.save
          flash[:notice] = t('c.topics.create.success')
          redirect url(:topics, :show, :forum_id => @forum, :id => @topic)
        else
          render 'topics/new'
        end
      else
        redirect url(:forums, :show, :id => @forum)
      end
    end    
                
  # edit  

    get :edit, :map => '/forums/:forum_id/topics/edit/:id' do
      @topic = Topic.find params[:id]
      access_denied unless @topic.editable_by? current_user
      render 'topics/edit'
    end
    
    put :update, :map => '/forums/:forum_id/topics/edit/:id' do
      @topic = Topic.find params[:id]
      access_denied unless @topic.editable_by? current_user
      unless cancelled?        
        if @topic.update_with_updater params[:topic], current_user
          flash[:notice] = t('c.topics.update.success')
          redirect url(:topics, :show, :forum_id => @topic.forum_id, :id => @topic)
        else
          render 'topics/edit'
        end
      else
        redirect url(:topics, :show, :forum_id => @topic.forum_id, :id => @topic)
      end
    end   
    
  # destroy  

    get :destroy, :map => '/forums/:forum_id/topics/destroy/:id' do
      admin_mod_required
      @topic = Topic.find params[:id]
      render 'topics/destroy'
    end
    
    delete :destroy, :map => '/forums/:forum_id/topics/destroy/:id' do
      admin_mod_required
      t = Topic.find params[:id]
      t.destroy
      flash[:notice] = t('c.topics.destroy.success')
      redirect url(:forums, :show, :id => t.forum)
    end 

  # switch stick
     
    put :switch_stick, :with => :id do
      admin_mod_required
      t = Topic.find params[:id]
      t.toggle! :stuck
      redirect url(:topics, :show, :forum_id => t.forum_id, :id => t)
    end 
        
  # switch lock posts
     
    put :switch_lock_posts, :with => :id do
      admin_mod_required
      t = Topic.find params[:id]
      t.toggle! :posts_locked
      redirect url(:topics, :show, :forum_id => t.forum_id, :id => t)
    end 

  # quote
  
    get :quote, :with => :id, :provides => :js do
      @topic = Topic.find params[:id]
      render 'topics/quote'   
    end             
end




