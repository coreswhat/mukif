
class Torrent < ActiveRecord::Base

  # finders concern

  def self.paginate_user_torrents(user, params, args)
    a = scoped_by_active(true).paginate_by_user_id user,
                                                   :order => order_by(params[:order_by], params[:desc]),
                                                   :page => params[:page],
                                                   :per_page => args[:per_page]
    a
  end

  def self.paginate_user_bookmarked_torrents(user, params, include_inactives, args)
    a = paginate :conditions => paginate_user_bookmarked_torrents_conditions(user, include_inactives),
                 :order => 'name',
                 :page => params[:page],
                 :per_page => args[:per_page]
     a.each {|t| t.bookmarked = true} if a
     a
  end


  def self.paginate_user_stuck_torrents(user, params, set_bookmarked, args)
    a = Torrent.paginate :conditions => paginate_user_stuck_torrents_conditions(user),
                         :order => 'leechers_count DESC, name',
                         :page => params[:page],
                         :per_page => args[:per_page]
    set_bookmarked_batch(user, a) if a && set_bookmarked
    a
  end

  def paginate_comments(params, args)
    Comment.paginate_by_torrent_id self,
                                   :order => 'created_at',
                                   :page => params[:page],
                                   :per_page => args[:per_page]
  end
  
  def paginate_rewards(params, args)
    Reward.paginate_by_torrent_id self,
                                  :order => 'created_at',
                                  :page => params[:page],
                                  :per_page => args[:per_page]
  end

  def self.search(params, searcher, args)
    paginate :conditions => search_conditions(params, searcher),
             :order => order_by(params[:order_by], params[:desc]),
             :page => params[:page],
             :per_page => args[:per_page]
  end
  
  private
  
    def self.order_by(order_by, desc)
      "#{order_by}#{' DESC' if desc == '1'}"
    end

    def self.paginate_user_bookmarked_torrents_conditions(user, include_inactives)
      s, h = '', {}
      unless include_inactives
        s << 'active = TRUE '
        previous = true
      end
      s << 'AND ' if previous
      s << 'id in (SELECT torrent_id FROM bookmarks WHERE user_id = :user_id)'
      h[:user_id] = user.id
      [s, h]
    end

    def self.paginate_user_stuck_torrents_conditions(user)
      s, h = '', {}
      s << 'active = TRUE AND seeders_count = 0 AND leechers_count > 0 '
      s << 'AND '
      s << '(user_id = :user_id OR id IN (SELECT torrent_id FROM snatches WHERE user_id = :user_id))'
      h[:user_id] = user.id
      [s, h]
    end

    def self.search_conditions(params, searcher)
      s, h = '', {}
      if searcher.admin_mod?
        if params[:filter] == 'inactive'
          s << 'active = FALSE '
          previous = true
        end
      else
        s << 'active = TRUE '
        previous = true
      end
      unless params[:types].blank?
        a = params[:types].dup.map(&:to_i) # convert to integers
        s << 'AND ' if previous
        s << "type_id IN (#{a.join(', ')}) "
        previous = true
      end
      if !params[:filter].blank? && params[:filter] != 'inactive'
        s << 'AND ' if previous
        case params[:filter] 
          when 'free'
            s << 'free = TRUE '
          when 'alive'
            s << 'seeders_count > 0 '
          when 'dead'
            s << 'seeders_count = 0 '
        end
        previous = true
      end      
      unless params[:keywords].blank?
        
        s << 'AND ' if previous
        s << 'id IN (SELECT torrent_id FROM torrent_fulltexts WHERE MATCH(name, description) AGAINST (:keywords IN BOOLEAN MODE)) '
        h[:keywords] = params[:keywords]
        previous = true
      end
      unless params[:format_id].blank?
        s << 'AND ' if previous
        s << 'format_id = :format_id '
        h[:format_id] = params[:format_id].to_i
        previous = true
      end
      unless params[:country_id].blank?
        s << 'AND ' if previous
        s << 'country_id = :country_id '
        h[:country_id] = params[:country_id].to_i
        previous = true
      end
      [s, h]
    end
end
