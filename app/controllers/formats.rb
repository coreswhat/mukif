
Mukif.controllers :formats do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @formats = Format.find :all
    render 'formats/index' 
  end
  
  # new
  
    get :new do
      @format = Format.new
      render 'formats/new'
    end
    
    post :create do
      @format = Format.new params[:format]  
      if @format.save
        redirect url(:formats, :index)
      else
        render 'formats/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @format = Format.find params[:id]
      render 'formats/edit' 
    end
    
    put :update, :with => :id do
      @format = Format.find params[:id]
      if @format.update_attributes params[:format]
        redirect url(:formats, :index)
      else
        render 'formats/edit'
      end
    end
  
  # destroy
          
    delete :destroy, :with => :id do 
      t = Format.find params[:id]
      if Torrent.scoped_by_format_id(t).find(:first) || Wish.scoped_by_format_id(t).find(:first)
        flash[:error] = 'format is in use'
      else
        t.destroy
      end
      redirect url(:formats, :index)
    end   
end



