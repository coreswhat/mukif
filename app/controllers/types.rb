
Mukif.controllers :types do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @types = Type.find :all
    render 'types/index' 
  end
  
  # new
  
    get :new do
      @type = Type.new
      render 'types/new'
    end
    
    post :create do
      @type = Type.new params[:type]  
      if @type.save
        redirect url(:types, :index)
      else
        render 'types/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @type = Type.find params[:id]
      render 'types/edit' 
    end
    
    put :update, :with => :id do
      @type = Type.find params[:id]
      if @type.update_attributes params[:type]
        redirect url(:types, :index)
      else
        render 'types/edit'
      end
    end
  
  # destroy
         
    delete :destroy, :with => :id do  
      t = Type.find params[:id]
      if Torrent.scoped_by_type_id(t).find(:first) || Wish.scoped_by_type_id(t).find(:first)
        flash[:error] = 'type is in use'
      else
        t.destroy
      end
      redirect url(:types, :index)
    end   
end



