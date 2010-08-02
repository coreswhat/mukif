
class AnnounceLog < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :torrent
  
  def self.search(params, args)
    paginate :conditions => search_conditions(params),
             :order => order_by(params[:order_by], params[:desc]),
             :page => params[:page],
             :per_page => args[:per_page]
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
  end

  private
  
    def self.order_by(order_by, desc)
      "#{order_by}#{' DESC' if desc == '1'}"
    end

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
