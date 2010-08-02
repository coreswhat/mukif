
Mukif.controllers :sources do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @sources = Source.find :all
    render 'sources/index' 
  end
  
  # new
  
    get :new do
      @source = Source.new
      render 'sources/new'
    end
    
    post :create do
      @source = Source.new params[:source]  
      if @source.save
        redirect url(:sources, :index)
      else
        render 'sources/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @source = Source.find params[:id]
      render 'sources/edit' 
    end
    
    put :update, :with => :id do
      @source = Source.find params[:id]
      if @source.update_attributes params[:source]
        redirect url(:sources, :index)
      else
        render 'sources/edit'
      end
    end
  
  # destroy
           
    delete :destroy, :with => :id do
      Source.destroy params[:id]
      redirect url(:sources, :index)
    end   
end



