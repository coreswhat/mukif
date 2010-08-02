
Mukif.controllers :logs do
  
  before { logged_in_required }
  
  get :index do
    process_search_keywords 3
    
    set_default_order_by 'created_at', true
    
    @logs = Log.search params, current_user, :per_page => settings.c[:page_size][:logs]
    @logs.setup_pagination :logs, :index if @logs
    
    escape_search_keywords
    render 'logs/index'
  end 
end