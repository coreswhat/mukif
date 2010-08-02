
Mukif.helpers do

  # controller

    def tracker_properties
      h = {}

      h[:announce_url] = tracker_announce_url(current_user.passkey)
      
      h[:test_url] = "#{h[:announce_url]}?info_hash=none&peer_id=none&port=0&uploaded=0&downloaded=0&left=0&numwant=1"
      
      p = Peer.find :first, :order => 'last_action_at DESC'
      h[:last_peer_activity] = p ? p.last_action_at : nil
      
      h[:peers_count] = Peer.count
      
      h[:announce_logs_count] = AnnounceLog.count
      
      h
    end

    def env_properties
      h = {}

      h[:server_hostname] = %x{uname -a}

      h[:server_time] = windows? ? "#{%x{echo %DATE%}} #{%x{echo %TIME%}}" : %x{date}
     
      h[:database_time] = ActiveRecord::Base.connection.select_all('SELECT NOW()')[0]['NOW()']

      h[:ruby_version] = "#{RUBY_VERSION} (#{RUBY_PLATFORM})"

      h[:ruby_gems_version] = Gem::RubyGemsVersion

      if defined? Bundler
        h[:bundler_version] = Bundler::VERSION
      end

      if defined? PhusionPassenger
        h[:passenger_version] = PhusionPassenger::VERSION_STRING
      end

      h[:rack_version] = ::Rack.release

      h[:padrino_version] = Padrino.version
      h[:padrino_env] = Padrino.env

      db = ActiveRecord::Base.configurations[Padrino.env.to_sym]
      h[:database] = "#{db[:database]} (#{db[:adapter]})"

      h[:padrino_root] = Padrino.root

      logger_level = Padrino.logger.level
      h[:logger_level] = "#{logger_level} (#{logger_level_description logger_level})"

      h[:locale] = I18n.locale

      if false #CACHE_ENABLED
        unless CACHE.servers.blank?
          a = []
          CACHE.servers.each do |server|
            s = {}
            s[:host] = server.host
            s[:port] = server.port
            s[:status] = server.status
            s[:stats] = CACHE.stats["#{server.host}:#{server.port}"].symbolize_keys!
            a << s
          end
          h[:memcached_servers] = a
        end
      end
      h
    end

    def logger_level_description(level)
      (0..5).include?(level) ? ['debug', 'info', 'warn', 'error', 'fatal', 'unknown'][level] : '????'
    end

    def windows?
      RUBY_PLATFORM.downcase =~ /mswin|mingw|bccwin/
    end
end