
Mukif.helpers do

  # controller
  
    def cancelled?
      true if params[:cancel]
    end
    
    def empty_flash?
      !(flash.has(:error) || flash.has(:alert) || flash.has(:notice))  
    end
    
    def after_logged_in_required # callback from authentication
      current_user.register_access
      staff_alerts
    end

    def staff_alerts
      if current_user.admin?
        def current_user.error_log?
          ErrorLog.has?
        end
      elsif current_user.mod?
        def current_user.open_report?
          Report.has_open?
        end
      end
    end
    
    def load_app_params
      @app_params = AppParam.params_hash
    end
    
    def set_default_order_by(column, desc = false) 
      params[:order_by], params[:desc] = column, (desc ? '1' : nil) if params[:order_by].blank?
    end
    
    def set_default_page 
      params[:page] = '1' if params[:page].blank?
    end    
    
    def process_search_keywords(max_keywords = nil)
      # note: 4 is the default minimum size of a search term for mysql
      
      p = params[:keywords]
            
      unless p.blank?
        a = []                        
        
        p.gsub!(/"[\w\s]+"/) do |match|
          a << match if match.size >= (2 + 4) # quoted term, e.g. "nice orange"
          ''
        end
        
        p.gsub!(/\w+/) do |match|
          a << match if match.size >= 4 # non quoted term
          ''
        end
      
        a = a[0, max_keywords] if max_keywords
        a.uniq!
        
        params[:keywords] = a.join(' ')
      end
    end  
    
    def escape_search_keywords
      params[:keywords] = escape_html params[:keywords] # so that '"' is rendered in text fields
    end     
    
    def get_uploaded_file_data(param)      
      if param
        logger.debug ":-) uploaded file param class: #{param.class.name}"
        if param.is_a?(Hash)
          param[:tempfile].read
        else
          raise 'unable to handle uploaded file!'
        end
      end
    end
    
  # view
    
    def page_name(s)
      content_for(:page_name, "#{settings.c[:app_name]} : : #{s}") if yield_content(:page_name).blank?
    end
    
    def field_error(message)
      message = message[0] if message.is_a? Array
      message.blank? ? nil : content_tag(:div, message, :class => 'field_error')
    end    
        
    def number_to_ratio(n)
      number_with_precision n, t('number.ratio.format')
    end

    def highlight_true_false(b, default_text = nil, false_text = nil)
      content_tag(:span, b ? (default_text || 'true') : (false_text || default_text || 'false'), :class => b ? 'true' : 'false')
    end
    
    def highlight_false(b, default_text = nil, false_text = nil)
      content_tag(:span, b ? (default_text || 'true') : (false_text || default_text || 'false'), :class => b ? nil : 'false')
    end
  
    def highlight_true(b, default_text = nil, false_text = nil)
      content_tag(:span, b ? (default_text || 'true') : (false_text || default_text || 'false'), :class => b ? 'true' : nil)
    end

    def avatar_image(user)
      image_url = user.avatar.blank? ? settings.c[:users][:default_avatar] : user.avatar
      image_tag image_url, :class => 'avatar', :alt => 'Avatar'
    end
  
    def country_image(c)
      c ? image_tag(c.image, :class => 'flag', :alt => c.description, :title => c.description) : '-'
    end
  
    def spinner_image
      image_tag 'spinner.gif', :class => 'spinner'
    end    
      
    def textual_time_interval(given_time, sufix = nil) # very rough
      raise 'given_time cannot be nil!' unless given_time
      
      p = (Time.now.to_i - given_time.to_i).abs
      
      value, unit = case
        when p < 1.minute
          [ p > 0 ? p : 1, 'seconds' ]
        when p < 1.hour
          [ p / 1.minute, 'minutes' ]
        when p < 2.days
          [ p / 1.hour, 'hours' ]
        when p < 1.month
          [ p / 1.day, 'days' ]
        when p < 2.years
          [ p / 1.month, 'months' ]
        else
          [ p / 1.year, 'years' ]
      end
      s = t("datetime.textual.#{unit}", :count => value.to_i)
      s << ' ' << sufix if sufix
      s
    end
        
    def textual_data_amount(a)
      if a.nil? || a == 0
        value = 0
      else
        a = a.to_i        
        value, unit = case
          when a < 1.kilobytes
            [ a, 'B' ]
          when a < 1.megabyte
            [ a / 1.kilobyte.to_f, 'KB' ]
          when a < 1.gigabyte
            [ a / 1.megabyte.to_f, 'MB' ]
          when a < 1.terabyte
            [ a / 1.gigabyte.to_f, 'GB' ]
          when a < 1.petabyte
            [ a / 1.terabyte.to_f, 'TB' ]
          else
            [ a / 1.petabyte.to_f, 'PB' ]
        end
      end
      "#{number_with_precision value, t('number.data_amount.format')} #{unit}"
    end
end





