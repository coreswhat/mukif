
class Snatch < ActiveRecord::Base
  
  belongs_to :torrent
  belongs_to :user
  
  def self.paginate_torrent_snatches(params, args)
    Snatch.paginate_by_torrent_id params[:torrent_id],
                                  :order => 'created_at DESC',
                                  :page => params[:page],
                                  :per_page => args[:per_page],
                                  :include => :user
  end 
  
  def self.paginate_user_snatches(params, args)
    Snatch.paginate_by_user_id params[:user_id],
                               :order => 'created_at DESC',
                               :page => params[:page],
                               :per_page => args[:per_page],
                               :include => :torrent
  end   
end
