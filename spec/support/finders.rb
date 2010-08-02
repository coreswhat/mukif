
module Finders  
  
  # account recovery
  
    def find_account_recovery_by_user(user)
      AccountRecovery.find_by_user_id(user)
    end
    
  # bg_task
       
    def find_bg_task_by_name(name)
      BgTask.find_by_name name
    end
    
  # bg_task_log
       
    def find_bg_task_log_by_bg_task_name(bg_task_name)
      BgTaskLog.find_by_bg_task_name bg_task_name
    end  
    
  # bg_task_param
       
    def find_bg_task_param_by_bg_task_and_name(bg_task, name)
      BgTaskParam.find_by_bg_task_id_and_name bg_task, name
    end        

  # bookmark
       
    def find_bookmark_by_torrent_and_user(torrent, user)
      Bookmark.find_by_torrent_id_and_user_id torrent, user
    end
        
  # comment
       
    def find_comments
      Comment.find :all, :order => 'body'
    end
    
    def find_comment_by_body(body)
      Comment.find_by_body body
    end
    
    def find_comment_by_torrent_and_body_and_user(torrent, body, user)
      Comment.find_by_torrent_id_and_body_and_user_id(torrent, body, user)
    end
    
  # forum
    
    def find_forum_by_name(name)
      Forum.find_by_name(name)
    end
    
  # invitation
    
    def find_invitations
      Invitation.find :all, :order => 'email'
    end
  
    def find_invitation_by_code(code)
      Invitation.find_by_code(code)
    end
    
    def find_invitation_by_email(email)
      Invitation.find_by_email(email)
    end
    
  # login attempt
    
    def find_login_attempts
      LoginAttempt.find :all
    end
  
    def find_login_attempt_by_ip(ip)
      LoginAttempt.find_by_ip(ip)
    end

  # mapped file
  
    def find_mapped_file_by_torrent_and_name_and_size(t, name, size)
      MappedFile.find_by_torrent_id_and_name_and_size(t, name, size)
    end

  # message
  
    def find_messages
      Message.find :all, :order => 'subject, folder'
    end
    
    def find_message_by_subject(subject)
      Message.find_by_subject subject
    end

    def find_message_by_receiver_and_subject(receiver, subject)
      Message.find_by_receiver_id_and_subject(receiver, subject)
    end

    def find_message_by_receiver_and_sender(receiver, sender)
      Message.find_by_receiver_id_and_sender_id(receiver, sender)
    end

    def find_message_by_subject_and_owner_and_receiver_and_sender(subject, owner, receiver, sender)
      Message.find_by_subject_and_owner_id_and_receiver_id_and_sender_id(subject, owner, receiver, sender)
    end    

    def find_message_by_subject_and_owner_and_receiver_and_folder(subject, owner, receiver, folder)
      Message.find_by_subject_and_owner_id_and_receiver_id_and_folder(subject, owner, receiver, folder)
    end   
    
  # peer
  
    def find_peer_by_torrent_and_user_and_ip_and_port(t, u, ip, port)
      Peer.find_by_torrent_id_and_user_id_and_ip_and_port t, u, ip, port
    end  
    
  # peer_conn
  
    def find_peer_conn_by_ip_and_port(ip, port)
      PeerConn.find_by_ip_and_port(ip, port)
    end
    
  # post
  
    def find_post_by_body(body)
      Post.find_by_body(body)
    end
  
    def find_post_by_topic_and_body_and_user(topic, body, user)
      Post.find_by_topic_id_and_body_and_user_id(topic, body, user)
    end
    
  # report
  
    def find_report_by_target_and_reason(target, reason)
      Report.find_by_target_label_and_reason(Report.make_target_label(target), reason)
    end  
    
    def find_report_by_reason_and_target_path(reason, target_path)
      Report.find_by_reason_and_target_path(reason, target_path)
    end  

    def find_report_by_reporter_and_target_label(reporter, target_label)
      Report.find_by_reporter_id_and_target_label(reporter, target_label)
    end    
    
  # reward
  
    def find_reward_by_torrent_and_user_and_amount(torrent, user, amount)
      Reward.find_by_torrent_id_and_user_id_and_amount(torrent, user, amount)
    end 
        
  # topic
  
    def find_topic_by_title(title)
      Topic.find_by_title(title)
    end
    
    def find_topic_by_forum_and_title_and_user(forum, title, user)
      Topic.find_by_forum_id_and_title_and_user_id(forum, title, user)
    end
  
  # torrent
    
    def find_torrents
      Torrent.find :all, :order => 'name'
    end
  
    def find_torrent_by_name(name)
      Torrent.find_by_name name
    end
    
  # user
   
    def find_users
      User.find :all, :order => 'username'
    end
  
    def find_user_by_username(username)
      User.find_by_username username
    end
      
  # wish 
    
    def find_wishes
      Wish.find :all, :order => 'name'
    end 
  
    def find_wish_by_name(name)
      Wish.find_by_name name
    end 
    
  # wish_bounty
  
    def find_wish_bounties
      WishBounty.find :all, :order => 'amount'
    end
    
    def find_wish_bounty_by_wish_and_user_and_amount(wish, user, amount)
      WishBounty.find_by_wish_id_and_user_id_and_amount(wish, user, amount)
    end

  # wish_comment
       
    def find_wish_comments
      WishComment.find :all, :order => 'body'
    end
    
    def find_wish_comment_by_body(body)
      WishComment.find_by_body body
    end
    
    def find_wish_comment_by_wish_and_body_and_user(wish, body, user)
      WishComment.find_by_wish_id_and_body_and_user_id(wish, body, user)
    end
end  
  
  



