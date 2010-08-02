
Mukif.controllers :announce_logs do
  
  before { logged_in_required }
  before { admin_required }
  
  get :index do
    set_default_order_by 'created_at', true
    @announce_logs = AnnounceLog.search params, :per_page => settings.c[:page_size][:announce_logs]
    @announce_logs.setup_pagination :announce_logs, :index, settings.c[:browse][:default_desc][:announce_logs] if @announce_logs
    render 'announce_logs/index'
  end  
  
  # destroy all
     
    delete :destroy_all do
      AnnounceLog.delete_all
      redirect url(:announce_logs, :index)
    end 
end