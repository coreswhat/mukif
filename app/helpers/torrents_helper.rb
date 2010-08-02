
Mukif.helpers do
  
  class ::TorrentFileError < StandardError # '::' or ruby 1.9.1 cant find it
    attr_accessor :args
    
    def initialize(error_key, args)
      super error_key
      self.args = args
    end
  end
  
  # controller

    def redirect_to_torrent(t = nil)      
      redirect url(:torrents, :show, :id => t || @torrent)
    end

    def tracker_announce_url(passkey)
      settings.c[:tracker][:url].gsub('PASSKEY', passkey)
   end

    def torrent_available?(t = nil)
      t ||= @torrent
      !t.blank? && (t.active? || current_user.admin_mod?)
    end

    def set_collections_for_torrent
      @types = Type.find :all
      @formats = Format.find :all
      @sources = Source.find :all
      @countries = Country.all 
    end

    def torrent_file_error(error_key, args = {})
      raise TorrentFileError.new(error_key, args)
    end

    def get_uploaded_torrent_file_data(file_param)
      ensure_uploaded_torrent_file_acceptable file_param
      get_uploaded_file_data file_param # app_helper
    end

    def ensure_uploaded_torrent_file_acceptable(f)
      if f.blank?
        torrent_file_error 'required'
      else
        if f.is_a?(Hash)
          max_size_kb = settings.c[:torrents][:file_max_size_kb]
          case
            when f[:tempfile].blank?
              torrent_file_error 'required'
            when !f[:filename].downcase.ends_with?('.torrent')
              torrent_file_error 'type'
            when f[:tempfile].size > max_size_kb.kilobytes
              torrent_file_error 'size', :max_size => max_size_kb
          end            
        else
          raise 'unable to handle uploaded torrent file!'
        end
      end
    end 
    
  # controller and view
    
    def torrent_file_name(t, prefix = nil)
      s = ''
      s << "[#{ prefix }] " unless prefix.blank?
      s << t.name[0, 40].gsub(/[^\w\-\s]/, '')
      s << '.torrent'
    end
    
  # view
  
    def torrent_link(t, display_format = nil, text_limit = nil)
      html_options = {}

      if display_format
        html_options[:class] = case display_format
          when :browse
            'torrent'
          when :compact
            'torrent_compact'
        end           
        html_options[:class] << ' torrent_inactive' unless t.active?
        html_options[:class] << ' torrent_dead' if t.seeders_count == 0
      end
      
      if text_limit
        text = truncate(t.name, :length => text_limit)
        html_options[:title] = t.name if t.name.size > text_limit
      else
        text = t.name
      end
      
      link_to text, url(:torrents, :show, :id => t), html_options
    end
  
    def torrent_download_link(t, text_link = false)
      if text_link
        label = torrent_file_name t
      else
        label = image_tag('download.png', :title => t('h.torrents_helper.torrent_download_link.title'), :alt => t('h.torrents_helper.torrent_download_link.title'))
      end
      link_to label, url(:torrents, :download, :id => t)
    end
  
    def torrent_additional_info(t, new_torrent_threshold_time = nil)
      s = ''
      if t.format_id
        s << t.format.description
        previous = true
      end
      if t.source_id
        s << ' | ' if previous
        s << t.source.description
        previous = true
      end    
      if t.country_id
        s << ' | ' if previous
        s << t.country.description
        previous = true
      end
      if t.year
        s << ' | ' if previous
        s << t.year.to_s
        previous = true
      end
      if t.free?
        s << ' | ' if previous
        s << content_tag(:span, t('h.torrents_helper.torrent_additional_info.free_label'), :class => 'torrent_free_label')
        previous = true
      end      
      if new_torrent_threshold_time && (t.created_at + new_torrent_threshold_time.minutes > Time.now)        
        s << ' | ' if previous
        s << content_tag(:span, 'new', :class => 'torrent_new_label')        
      end      
      css_class = t.seeders_count > 0 ? 'torrent_info' : 'torrent_dead_info'
      s.blank? ? nil : content_tag(:span, "[ #{s} ]", :class => "#{css_class} no_wrap")
    end
  
    def bookmark_textual_link(t)
      span = content_tag(:span, bookmark_text(t), :id => 'bookmark_span') 
      link_to span, 
              url(:torrents, :bookmark, :id => t, :format => :js), 
              :class => 'bookmark_link', :remote => true, :method => :put
    end
    
    def bookmark_text(t)
      t.bookmarked? ? t('h.torrents_helper.bookmark_text.unbookmark') : t('h.torrents_helper.bookmark_text.bookmark')
    end 
  
    def bookmark_image_link(t)
      span = content_tag(:span, bookmark_image(t), :id => "bookmark_span_#{t.id}")
      link_to span, 
              url(:torrents, :bookmark, :id => t, :image => '1', :format => :js), 
              :class => 'bookmark_link', :remote => true, :method => :put
    end
    
    def bookmark_image(t)
      if t.bookmarked? 
        image_tag('unbookmark.png', :class => 'bookmark', :title => t('h.torrents_helper.bookmark_image.unbookmark'))
      else
        image_tag('bookmark.png', :class => 'bookmark', :title => t('h.torrents_helper.bookmark_image.bookmark'))
      end
    end    
end








