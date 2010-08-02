
Mukif.controllers :clients do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @clients = Client.find :all
    render 'clients/index' 
  end
  
  # new
  
    get :new do
      @client = Client.new
      render 'clients/new'
    end
    
    post :create do
      @client = Client.new params[:client]  
      if @client.save
        redirect url(:clients, :index)
      else
        render 'clients/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @client = Client.find params[:id]
      render 'clients/edit' 
    end
    
    put :update, :with => :id do
      @client = Client.find params[:id]
      if @client.update_attributes params[:client]
        redirect url(:clients, :index)
      else
        render 'clients/edit'
      end
    end
  
  # destroy
       
    delete :destroy, :with => :id do
      Client.destroy params[:id]
      redirect url(:clients, :index)
    end   
end