
Mukif.controllers :snatches do
  
  before { logged_in_required }
  
  # user snatches

    get :user_snatches, :map => 'users/:user_id/snatches' do
      @user = User.find params[:user_id]
      if @user != current_user && !current_user.admin?
        access_denied unless @user.display_snatches?
      end
      @snatches = Snatch.paginate_user_snatches params, :per_page => settings.c[:page_size][:user_snatches]
      @snatches.setup_pagination :snatches, :user_snatches if @snatches      
      render 'snatches/user_snatches' 
    end
  
  # torrent snatches

    get :torrent_snatches, :map => 'torrents/:torrent_id/snatches' do
      admin_mod_required
      @torrent = Torrent.find params[:torrent_id]
      @snatches = Snatch.paginate_torrent_snatches params, :per_page => settings.c[:page_size][:torrent_snatches]
      @snatches.setup_pagination :snatches, :torrent_snatches if @snatches
      render 'snatches/torrent_snatches' 
    end
end
