
class Peer < ActiveRecord::Base

  # finders concern

  def self.search(params, args)
    paginate :conditions => search_conditions(params),
             :order => 'started_at DESC',
             :page => params[:page],
             :per_page => args[:per_page]
  end

  def self.paginate_torrrent_peers(t, params, args)
    paginate_by_torrent_id t,
                           :order => 'started_at DESC',
                           :page => params[:page],
                           :per_page => args[:per_page]
  end

  def self.paginate_user_peers(u, seeding, params, args)
    paginate_by_user_id u,
                        :conditions => {:seeder => seeding},
                        :order => 'started_at DESC',
                        :page => params[:page],
                        :per_page => args[:per_page],
                        :include => :torrent 
  end
  
  private

    def self.search_conditions(params)
      s, h = '', {}
      unless params[:user_id].blank?
        s << 'user_id = :user_id '
        h[:user_id] = params[:user_id].to_i
        previous = true
      end
      unless params[:torrent_id].blank?
        s << 'AND ' if previous
        s << 'torrent_id = :torrent_id '
        h[:torrent_id] = params[:torrent_id].to_i
        previous = true
      end
      if params[:seeder] == '1'
        params[:leecher] = '0'
        s << 'seeder = TRUE '
        previous = true
      elsif params[:leecher] == '1'
        s << 'seeder = FALSE '
        previous = true
      end
      unless params[:ip].blank?
        s << 'AND ' if previous
        s << 'ip = :ip '
        h[:ip] = params[:ip]
        previous = true
      end
      unless params[:port].blank?
        s << 'AND ' if previous
        s << 'port = :port '
        h[:port] = params[:port].to_i
      end
      [s, h]
    end
end