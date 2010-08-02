
Mukif.controllers :wish_bounties do
  
  before { logged_in_required }

  get :index, :map => '/wishes/:wish_id/bounties' do
    @wish = Wish.find params[:wish_id]
    @wish_bounties = @wish.paginate_bounties params, :per_page => settings.c[:page_size][:wish_bounties]
    @wish_bounties.setup_pagination :wish_bounties, :index if @wish_bounties    
    render 'wish_bounties/index'    
  end

  # new
  
    get :new, :map => '/wishes/:wish_id/bounties/new' do
      @wish = Wish.find params[:wish_id]
      access_denied unless @wish.open?
      render 'wish_bounties/new' 
    end
    
    post :create, :map => '/wishes/:wish_id/bounties/new' do
      @wish = Wish.find params[:wish_id]
      access_denied unless @wish.open?
      unless cancelled?
        bounty_amount = parse_bounty_amount
        if bounty_amount
          if current_user.uploaded >= bounty_amount
            WishBounty.kreate! @wish, current_user, bounty_amount
            flash[:notice] = t('c.wish_bounties.create.success')
            redirect url(:wish_bounties, :index, :wish_id => @wish, :page => 'last')
          else
            flash.now[:error] = t('c.wish_bounties.create.insufficient_upload_credit')
            render 'wish_bounties/new'
          end
        else
          flash.now[:error] = t('c.wish_bounties.create.invalid_bounty_amount')
          render 'wish_bounties/new'
        end
      else
        redirect url(:wish_bounties, :index, :wish_id => @wish)
      end
    end

  # revoke

    get :revoke, :map => '/wishes/:wish_id/bounties/revoke/:id' do
      @wish_bounty = WishBounty.find params[:id]
      access_denied if @wish_bounty.user != current_user || @wish_bounty.revoked? || !@wish_bounty.wish.open?
      render 'wish_bounties/revoke' 
    end
    
    put :revoke, :map => '/wishes/:wish_id/bounties/revoke/:id' do
      @wish_bounty = WishBounty.find params[:id]
      access_denied if @wish_bounty.user != current_user || @wish_bounty.revoked? || !@wish_bounty.wish.open?
      unless cancelled?
        @wish_bounty.revoke!
        flash[:notice] = t('c.wish_bounties.revoke.success')        
      end
      redirect url(:wish_bounties, :index, :wish_id => @wish_bounty.wish)
    end
end





