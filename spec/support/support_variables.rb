
module SupportVariables
  
  def load_default_variables    
    # roles    
      @role_system     = make_role Role::SYSTEM
      @role_owner      = make_role Role::OWNER
      @role_admin      = make_role Role::ADMINISTRATOR
      @role_mod        = make_role Role::MODERATOR
      @role_user       = make_role Role::USER
      @role_defective  = make_role Role::DEFECTIVE
      @role_power_user = make_role 'power_user'
      @role_uploader   = make_role 'uploader'

    # users    
      @user_system    = make_system_user          
      @user_owner     = make_user 'joe-the-owner', @role_owner
      @user_admin     = make_user 'joe-the-admin', @role_admin
      @user_mod       = make_user 'joe-the-mod', @role_mod
      @user           = make_user 'joe-the-user', @role_user  
      @user_defective = make_user 'joe-the-defective', @role_defective  
      
      @user_power_user = make_user 'joe-the-power_user', @role_power_user
      
      @user_untouched = make_user('joe-the-untouched', @role_user).freeze
    
    # misc    
      @type   = make_type('test_type')
      @format = make_format('test_format')
      @source = make_source('test_source')
  end
  
  def load_user_variables 
    @user_two   = make_user('joe-the-user_two', @role_user)
    @user_three = make_user('joe-the-user_three', @role_user)
    @user_four  = make_user('joe-the-user_four', @role_user)
    @user_five  = make_user('joe-the-user_five', @role_user)
    
    @user_power_user_two = make_user('joe-the-power_user_2', @role_power_user)
    @user_mod_two        = make_user('joe-the-mod_two', @role_mod)
    @user_admin_two      = make_user('joe-the-admin_two', @role_admin)
    @user_owner_two      = make_user('joe-the-owner_two', @role_owner)
  end
  
  def load_torrent_variables
    @user_uploader         = make_user('joe-the-uploader', @role_user)
    @torrent               = make_torrent(@user_uploader)
    @torrent_two           = make_torrent(@user_uploader)
    @torrent_three         = make_torrent(@user_uploader)
    @user_commenter        = make_user('joe-the-commenter', @role_user)
    @comment               = make_comment(@torrent, @user_commenter)
    @user_rewarder         = make_user('joe-the-rewarder', @role_user)
    @user_reseed_requester = make_user('joe-the-requester', @role_user)    
    @user_snatcher         = make_user('joe-the-snatcher', @role_user)
    @user_snatcher_two     = make_user('joe-the-snatcher_two', @role_user)
  end
  
  def load_wish_variables
    @user_wisher           = make_user('joe-the-wisher', @role_user)
    @wish                  = make_wish(@user_wisher)  
    @wish_two              = make_wish(@user_wisher)
    @user_wish_commenter   = make_user('joe-wish-commenter', @role_user)   
    @wish_comment          = make_wish_comment(@wish, @user_wish_commenter)
    @user_wish_bounter     = make_user('joe-the-bounter', @role_user)
    @user_wish_bounter_two = make_user('joe-the-bounter_two', @role_user)
  end  
  
  def load_forum_variables
    @user_poster = make_user('joe-the-poster', @role_user)
    @forum = make_forum
    @topic = make_topic(@forum, @user_poster)
    @post  = make_post(@forum, @topic, @user_poster)
  end
  
  def load_message_variables
    @user_sender   = make_user('joe-the-sender', @role_user)    
    @user_receiver = make_user('joe-the-receiver', @role_user)
  end   
end





