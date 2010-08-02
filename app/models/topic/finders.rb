
class Topic < ActiveRecord::Base

  # finders concern

  def paginate_posts(params, args)
    Post.paginate_by_topic_id self,
                              :order => 'created_at',
                              :page => params[:page],
                              :per_page => args[:per_page]
  end
end