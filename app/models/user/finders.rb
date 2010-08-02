
class User < ActiveRecord::Base

  # finders concern

  def self.system_user
    find 1
  end

  def paginate_invitees(params, args)
    self.class.paginate_by_inviter_id self.id,
                                      :order => 'created_at',
                                      :page => params[:page],
                                      :per_page => args[:per_page]
  end

  def self.search(params, searcher, args)
    params[:username] = nil if params[:username] && params[:username].size < 3

    paginate :conditions => search_conditions(params, searcher),
             :order => order_by(params[:order_by], params[:desc]),
             :page => params[:page],
             :per_page => args[:per_page]
  end

  def self.top_uploaders(args)
    find :all, :order => 'uploaded DESC', :conditions => 'uploaded > 0', :limit => args[:limit]
  end

  def self.top_contributors(args)
    q, a = '', []
    q << 'SELECT user_id, COUNT(*) AS uploads '
    q << '  FROM torrents '
    q << '  WHERE user_id IS NOT NULL '
    q << '  GROUP BY user_id '
    q << '  ORDER BY uploads DESC '
    q << "  LIMIT #{args[:limit]}"
    result = connection.select_all q
    result.each {|r| a << {:user => find(r['user_id']), :torrents => r['uploads']} }
    a
  end

  private
  
    def self.order_by(order_by, desc)
      "#{order_by}#{' DESC' if desc == '1'}"
    end

    def self.search_conditions(params, searcher)
      s, h = '', {}
      unless searcher.system?
        s << 'id != 1 ' # hide system user
        previous = true
      end
      unless params[:username].blank?
        s << 'AND ' if previous
        s << 'username LIKE :username '
        h[:username] = "%#{params[:username]}%"
        previous = true
      end
      unless params[:role_id].blank?
        s << 'AND ' if previous
        s << 'role_id = :role_id '
        h[:role_id] = params[:role_id].to_i
        previous = true
      end
      unless params[:country_id].blank?
        s << 'AND ' if previous
        s << 'country_id = :country_id '
        h[:country_id] = params[:country_id].to_i
      end
      [s, h]
    end
end
