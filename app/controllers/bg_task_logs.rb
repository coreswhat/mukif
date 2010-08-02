
Mukif.controllers :bg_task_logs do
  
  before { logged_in_required }
  before { admin_required }
    
  get :index do
    @bg_task_logs = BgTaskLog.all :limit => 400
    render 'bg_task_logs/index'
  end
  
  # destroy all
      
    delete :destroy_all do
      BgTaskLog.delete_all
      redirect url(:bg_task_logs, :index)
    end
end