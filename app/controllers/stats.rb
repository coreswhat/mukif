
Mukif.controllers :stats do
  
  before  { logged_in_required }
  
  get :index do
    @stat = Stat.newest
    render 'stats/index'
  end
  
  # history

    get :history do
      admin_required
      @stats = Stat.paginate params, :per_page => settings.c[:page_size][:stats_history]
      @stats.setup_pagination :stats, :history if @stats      
      render 'stats/history'
    end
   
  # destroy all
   
    delete :destroy_all do
      owner_required
      Stat.delete_all
      redirect url(:stats, :history)
    end   
end


