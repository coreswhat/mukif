
class Forum < ActiveRecord::Base

  # finders concern

  def self.all
    find :all, :order => 'position'
  end
  
  def search(params, args)
    Topic.paginate_by_forum_id self,
                               :conditions => search_conditions(params),
                               :order => 'stuck DESC, last_post_at DESC',
                               :page => params[:page],
                               :per_page => args[:per_page]
  end

  def self.search_all(params, args)
    Topic.paginate :conditions => search_all_conditions(params),
                   :order => 'last_post_at DESC',
                   :page => params[:page],
                   :per_page => args[:per_page]
  end

  private

    def search_conditions(params)
      self.class.search_all_conditions params
    end

    def self.search_all_conditions(params)
      s, h = '', {}
      unless params[:keywords].blank?
        s << 'id IN (SELECT topic_id FROM topic_fulltexts WHERE MATCH(title, body) AGAINST (:keywords IN BOOLEAN MODE) ) '
        h[:keywords] = params[:keywords]
      end
      [s, h]
    end
end