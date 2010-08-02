
class Torrent < ActiveRecord::Base

  ar_sanitize :except => [ :info_hash ]
  
  has_many :mapped_files, :dependent => :destroy
  has_many :peers, :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  has_many :snatches, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :rewards, :dependent => :destroy
  
  has_one :raw_info, :dependent => :destroy
  has_one :torrent_fulltext, :dependent => :destroy
  has_one :wish, :dependent => :destroy
  
  belongs_to :user
  belongs_to :type
  belongs_to :format
  belongs_to :source
  belongs_to :country
  
  attr_accessor :announce_url
  attr_accessor :bookmarked # flag used to indicate if the torrent is bookmarked
  
  def add_error(attribute, key, args = {})
    errors.add attribute, I18n.t("m.torrent.errors.attributes.#{attribute.to_s}.#{key}", args)
  end
end

