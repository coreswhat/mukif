
Mukif.controllers :rewards, :parent => :torrent do
  
  before { logged_in_required }
  
  get :index do
    @torrent = Torrent.find params[:torrent_id]
    @rewards = @torrent.paginate_rewards params, :per_page => settings.c[:page_size][:rewards]
    @rewards.setup_pagination :rewards, :index if @rewards    
    render 'rewards/index'
  end

  # new
  
    get :new do
      @torrent = Torrent.find params[:torrent_id]
      access_denied if @torrent.user == current_user || @torrent.user.nil?
      render 'rewards/new'
    end
    
    post :create do
      @torrent = Torrent.find params[:torrent_id]
      access_denied if @torrent.user == current_user || @torrent.user.nil?
      unless cancelled?
        reward_amount = parse_reward_amount
        if reward_amount
          if current_user.uploaded >= reward_amount
            Reward.kreate! @torrent, current_user, reward_amount
            flash[:notice] = t('c.rewards.create.success')
            redirect url(:rewards, :index, :torrent_id => @torrent, :page => 'last')
          else
            flash.now[:error] = t('c.rewards.create.insufficient_upload_credit')
            render 'rewards/new'
          end
        else
          flash.now[:error] = t('c.rewards.create.invalid_reward_amount')
          render 'rewards/new'
        end
      else
        redirect url(:rewards, :index, :torrent_id => @torrent)
      end
    end    
end

