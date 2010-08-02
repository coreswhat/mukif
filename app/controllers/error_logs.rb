
Mukif.controllers :error_logs do
  
  before { logged_in_required }
  before { admin_required }
  
  get :index do
    @error_logs = ErrorLog.all :limit => 200  
    render 'error_logs/index'
  end

  # destroy
  
    delete :destroy, :with => :id do  
      ErrorLog.destroy params[:id]
      redirect url(:error_logs, :index)
    end 
  
  # destroy all
         
    delete :destroy_all do
      ErrorLog.delete_all
      redirect url(:error_logs, :index)
    end
end