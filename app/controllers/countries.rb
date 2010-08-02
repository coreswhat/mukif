
Mukif.controllers :countries do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @countries = Country.find :all
    render 'countries/index' 
  end
  
  # new
  
    get :new do
      @country = Country.new
      render 'countries/new'
    end
    
    post :create do
      @country = Country.new params[:country]  
      if @country.save
        redirect url(:countries, :index)
      else
        render 'countries/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @country = Country.find params[:id]
      render 'countries/edit' 
    end
    
    put :update, :with => :id do
      @country = Country.find params[:id]
      if @country.update_attributes params[:country]
        redirect url(:countries, :index)
      else
        render 'countries/edit'
      end
    end
  
  # destroy
       
    delete :destroy, :with => :id do
      Country.destroy params[:id]
      redirect url(:countries, :index)
    end   
end



