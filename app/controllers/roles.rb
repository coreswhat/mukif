
Mukif.controllers :roles do
  
  before { logged_in_required }
  before { owner_required }

  get :index do
    @roles = Role.find :all
    render 'roles/index' 
  end
  
  # new
  
    get :new do
      @role = Role.new
      render 'roles/new'
    end
    
    post :create do
      @role = Role.new params[:role] 
      @role.name = params[:role][:name]
      if @role.save
        redirect url(:roles, :index)
      else
        render 'roles/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @role = Role.find params[:id]
      render 'roles/edit' 
    end
    
    put :update, :with => :id do
      @role = Role.find params[:id]
      @role.name = params[:role][:name] unless @role.default?
      if @role.update_attributes params[:role]
        redirect url(:roles, :index)
      else
        render 'roles/edit'
      end
    end
      
  # destroy
         
    delete :destroy, :with => :id do  
      r = Role.find params[:id]      
      access_denied if r.default?
      unless User.scoped_by_role_id(r).find(:first)
        r.destroy
      else
        flash[:error] = 'role is in use'
      end
      redirect url(:roles, :index)
    end   
end


