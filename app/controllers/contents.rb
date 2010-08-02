
Mukif.controllers :contents do
  
  before { logged_in_required }
  
  # home
  
    get :index, :map => '/' do
      render 'contents/index'
    end
    
  # help
  
    get :help, :map => '/help' do
      render 'contents/help'
    end  

  # staff
  
    get :staff, :map => '/staff' do
      render 'contents/staff'
    end      
end
