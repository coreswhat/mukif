
Mukif.controllers :forums do
  
  before { logged_in_required }
  
  get :index do
    @forums = Forum.all
    render 'forums/index'
  end 
  
  # show
  
    get :show, :with => :id do
      process_search_keywords 3
      
      @forum = Forum.find params[:id]
      @topics = @forum.search params, :per_page => settings.c[:page_size][:forum_topics]
      @topics.setup_pagination :forums, :show if @topics
      
      escape_search_keywords
      render 'forums/show'
    end 
  
  # search
  
    get :search do     
      unless params[:keywords].blank?
        process_search_keywords 3 
        @topics = Forum.search_all params, :per_page => settings.c[:page_size][:forum_search_results]
        @topics.setup_pagination :forums, :search if @topics
        escape_search_keywords
        render 'forums/search'
      else
        redirect url(:forums, :index)
      end      
    end

  # new  

    get :new do
      owner_required
      @forum = Forum.new
      render 'forums/new'
    end
    
    post :create do
      owner_required
      @forum = Forum.new params[:forum]
      if @forum.save
        redirect url(:forums, :index)
      end
    end    
        
  # edit  

    get :edit, :with => :id do
      admin_required
      @forum = Forum.find params[:id]
      render 'forums/edit'
    end
    
    put :update, :with => :id do
      admin_required
      @forum = Forum.find params[:id]
      if @forum.update_attributes params[:forum]
        redirect url(:forums, :index)
      end
    end  
    
    
  # destroy  

    get :destroy, :with => :id do
      owner_required
      @forum = Forum.find params[:id]
      render 'forums/destroy'
    end
    
    delete :destroy, :with => :id do
      owner_required
      @forum = Forum.find params[:id]
      @forum.destroy
      flash[:notice] = 'forum successfully deleted'
      redirect url(:forums, :index)
    end 
    
  # switch lock topics
     
    put :switch_lock_topics, :with => :id do
      admin_required
      f = Forum.find params[:id]
      f.toggle! :topics_locked
      redirect url(:forums, :show, :id => f)
    end              
end
