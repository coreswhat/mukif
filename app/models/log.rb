
class Log < ActiveRecord::Base

  def self.kreate!(body, admin = false)
    create! :body => body, :admin => admin
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
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

    def self.search_conditions(params, searcher)
      s, h = '', {}
      if searcher.admin?
        if params[:admin] == '1'
          s << 'admin = TRUE '
          previous = true
        end
      else
        s << 'admin = FALSE '
        previous = true
      end
      unless params[:keywords].blank?
        s << 'AND ' if previous
        s << 'body LIKE :keywords'
        h[:keywords] = "%#{params[:keywords]}%"
      end
      [s, h]
    end
end
