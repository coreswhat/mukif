
module Makers
  
  require 'digest' 
  
  def random_s
    (Time.now.to_i * rand).to_i.to_s
  end
  
  # account_recovery
  
    def make_account_recovery(user, code = nil)
      r = AccountRecovery.new
      r.user = user 
      r.code = code || AccountRecovery.make_code
      r.save!
      r.reload
    end
    
  # app_param

    def make_app_param(name, yaml)
      p = AppParam.new
      p.name = name 
      p.yaml = yaml
      p.save!
      p.reload
    end

  # bg_task

    def make_bg_task(name, interval_minutes)
      t = BgTask.new
      t.name = name 
      t.interval_minutes = interval_minutes
      t.save!
      t.reload
    end
    
  # bookmark
  
    def make_bookmark(torrent, user)
      b = Bookmark.new
      b.torrent = torrent 
      b.user = user
      b.save!
      b.reload
    end
        
  # client
  
    def make_client(code)
      c = Client.new
      c.code = code 
      c.description = "client_#{code}"
      c.save!
      c.reload
    end
        
  # comment
  
    def make_comment(torrent, commenter, body = nil)
      c = Comment.new
      c.torrent = torrent 
      c.user = commenter
      c.body = body || "comment_body_#{random_s}"
      c.save!
      c.reload
    end
    
  # country
  
    def make_country(description = nil)
      c = Country.new
      c.description = description || "country_#{random_s}"
      c.save!
      c.reload
    end
    
  # format
  
    def make_format(description = nil)
      f = Format.new
      f.position = Format.count + 1 
      f.description = description || "format_#{random_s}"
      f.save!
      f.reload
    end
    
  # forum

    def make_forum(name = nil)
      f = Forum.new
      f.position = Forum.count + 1 
      f.name = name || "forum_#{random_s}"
      f.save!
      f.reload
    end
    
  # gender
  
    def make_gender(description = nil)
      g = Gender.new
      g.description = description || "gender_#{random_s}"
      g.save!
      g.reload
    end
    
  # invitation

    def make_invitation(inviter, email, code = nil)
      i = Invitation.new
      i.user = inviter 
      i.email = email
      i.code = code || Invitation.make_code
      i.save!
      i.reload
    end

  # login attempt

    def make_login_attempt(ip, count = nil)
      l = LoginAttempt.new
      l.ip = ip
      l.attempts_count = count || 0
      l.save!
      l.reload
    end
    
  # message

    def make_message(owner, receiver, sender, subject = nil, body = nil, folder = nil, save_message = true)
      m = Message.new
      m.owner = owner
      m.receiver = receiver
      m.sender = sender
      m.unread = true
      m.subject = subject || "message_subject_#{random_s}"
      m.body    = body    || "message_body_#{random_s}"
      m.folder  = folder  || Message::INBOX
      return m unless save_message
      m.save!
      m.reload
    end
    
  # peer

    def make_peer(t, u, ip, port, seeder, connectable = true)
      p = Peer.new 
      p.torrent = t
      p.user = u
      p.ip = ip
      p.port = port
      p.seeder = seeder
      p.peer_conn = find_peer_conn_by_ip_and_port(ip, port) || make_peer_conn(ip, port, connectable)
      p.started_at = Time.now
      p.last_action_at = Time.now
      p.save!
      p.reload
    end
     
  # peer_conn

    def make_peer_conn(ip, port, connectable = true)
      c = PeerConn.new 
      c.ip = ip
      c.port = port
      c.connectable = connectable
      c.save!
      c.reload
    end    
    
  # post

    def make_post(forum, topic, creator, body = nil)
      p = Post.new
      p.forum = forum 
      p.topic = topic 
      p.user = creator
      p.body = body || "post_body_#{random_s}"
      p.save! 
      p.reload
    end

  # report
  
    def make_report(reporter)
      r = Report.new
      r.reporter  = reporter
      r.target_label = "target_label [#{random_s}]"
      r.target_path = "targets/path/#{random_s}"
      r.reason = "reason_#{random_s}"
      r.save!
      r.reload
    end
    
  # reward
  
    def make_reward(torrent, rewarder, amount)
      r = Reward.new
      r.torrent = torrent
      r.user = rewarder
      r.amount = amount
      r.save!
      r.reload
    end
    
  # role
  
    def make_role(name)
      r = Role.new
      r.css_class = "role_#{name}.css"
      r.description = name.humanize.capitalize
      r.name = name
      r.save!
      r.reload
    end    

  # snatch
  
    def make_snatch(torrent, user)
      s = Snatch.new
      s.torrent = torrent
      s.user = user
      s.save!
      s.reload
    end

  # source
  
    def make_source(description = nil)
      s = Source.new
      s.position = Source.count + 1 
      s.description = description || "source_#{random_s}"
      s.save!
      s.reload
    end

  # style
  
    def make_style(description = nil)
      s = Style.new
      s.description = description || "style_#{random_s}"
      s.stylesheet = "#{s.description}.css"
      s.save!
      s.reload
    end
        
  # topic
    
    def make_topic(forum, creator, title = nil, body = nil)
      t = Topic.new
      t.forum = forum 
      t.user = creator
      t.title = title || "topic_#{random_s}"
      t.body = body || "topic_body_#{random_s}"
      t.save!
      t.reload
    end  
  
  # torrent

    def make_torrent(user, name = nil, type = nil, format = nil, save_torrent = true)
      t = Torrent.new
      t.user = user
      t.name = name || "torrent_#{random_s}"
      t.type = type || fetch_type
      t.format = format || fetch_format
      t.source = fetch_source
      t.country = fetch_country
      t.piece_length = 12345
      t.dir_name = 'dummy_dir'
      t.mapped_files = [ MappedFile.new(:name => "mapped_file_#{random_s}", :size => 12345) ]
      t.size = 123456
      t.files_count = 1      
      t.raw_info      = RawInfo.new(:data => Digest::SHA1.digest(rand.to_s))         
      t.info_hash     = Digest::SHA1.digest(t.raw_info.data)
      t.info_hash_hex = Digest.hexencode(t.info_hash).upcase
      return t unless save_torrent
      t.save! 
      t.reload
    end  

  # type
  
    def make_type(description = nil)
      t = Type.new
      t.position = Type.count + 1
      t.description = description || "type_#{random_s}"
      t.save!
      t.reload
    end
    
  # user

    def make_user(username, role = nil, save_user = true)
      u = User.new
      u.username = username 
      u.password = username 
      u.password_confirmation = username
      u.email = "#{username}@mail.com"
      u.style = fetch_style
      u.country = fetch_country
      u.gender = fetch_gender
      u.role = role || fetch_role
      return u unless save_user
      u.save! 
      u.reload
    end
    
    def make_system_user
      u = make_user('system', fetch_role(Role::SYSTEM), false)
      u.id = 1
      u.save!
      u.reload
    end

  # wish

    def make_wish(wisher, name = nil, type = nil, format = nil)
      w = Wish.new
      w.user = wisher
      w.name = name || "wish_#{random_s}"
      w.type = type || fetch_type
      w.format = format || fetch_format
      w.country = fetch_country
      w.save!
      w.reload                    
    end
    
  # wish bounty

    def make_wish_bounty(wish, bounter, amount, revoked = nil)
      b = WishBounty.new
      b.wish = wish 
      b.user = bounter 
      b.amount = amount
      b.revoked = false
      b.save!
      b.reload
    end

  # wish comment

    def make_wish_comment(wish, commenter, body = nil)
      c = WishComment.new
      c.wish = wish 
      c.user = commenter
      c.body = body || "wish_comment_body_#{random_s}"
      c.save!
      c.reload
    end
end





  