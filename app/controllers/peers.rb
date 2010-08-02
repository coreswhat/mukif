
Mukif.controllers :peers do
    
  before { logged_in_required }
  
  get :index do
    admin_required
    @peers = Peer.search params, :per_page => settings.c[:page_size][:peers]
    @peers.setup_pagination :peers, :index if @peers    
    render 'peers/index'
  end  
  
  # destroy
        
    delete :destroy, :with => :id do   
      admin_required
      Peer.destroy params[:id]
      redirect url(:peers, :index)
    end 
      
  # torrent peers

    get :torrent_peers, :map => 'torrents/:torrent_id/peers' do
      admin_mod_required
      @torrent = Torrent.find params[:torrent_id]
      @peers = Peer.paginate_torrrent_peers @torrent, params, :per_page => settings.c[:page_size][:torrent_peers]
      @peers.setup_pagination :peers, :torrent_peers if @peers 
      render 'peers/torrent_peers'
    end
    
  # user seeding peers

    get :user_seeding_peers, :map => 'users/:user_id/seeding' do
      @user = User.find params[:user_id]
      if @user != current_user && !current_user.admin?
        access_denied unless @user.display_seeding?
      else
        @display_ip_port = true  
      end
      @peers = Peer.paginate_user_peers @user, true, params, :per_page => settings.c[:page_size][:user_activity]
      @peers.setup_pagination :peers, :user_seeding_peers if @peers 
      render 'peers/user_seeding_peers'
    end
    
  # user leeching peers

    get :user_leeching_peers, :map => 'users/:user_id/leeching' do
      @user = User.find params[:user_id]
      if @user != current_user && !current_user.admin?
        access_denied unless @user.display_leeching?
      else
        @display_ip_port = true
      end
      @peers = Peer.paginate_user_peers @user, false, params, :per_page => settings.c[:page_size][:user_activity]
      @peers.setup_pagination :peers, :user_leeching_peers if @peers 
      render 'peers/user_leeching_peers'
    end    
end





