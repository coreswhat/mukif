
Mukif.controllers :app_params do
  
  before { logged_in_required }
  
  get :index do
    admin_required
    @app_params = AppParam.find :all
    render 'app_params/index'
  end
  
  # new
  
    get :new do
      owner_required
      @app_param = AppParam.new
      render 'app_params/new'
    end
    
    post :create do
      owner_required
      @app_param = AppParam.new params[:app_param]
      if @app_param.save
        redirect url(:app_params, :index)
      else
        render 'app_params/new'
      end
    end    
    
  # edit
  
    get :edit, :with => :id do
      admin_required
      @app_param = AppParam.find params[:id]
      render 'app_params/edit' 
    end
    
    put :update, :with => :id do
      admin_required
      @app_param = AppParam.find params[:id]
      if @app_param.update_attributes params[:app_param]
        redirect url(:app_params, :index)
      else
        render 'app_params/edit'
      end
    end
  
  # destroy
        
    delete :destroy, :with => :id do
      owner_required
      AppParam.destroy params[:id]
      redirect url(:app_params, :index)
    end         
end
