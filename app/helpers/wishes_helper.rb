
Mukif.helpers do

  # controller
  
    def redirect_to_wish(w = nil, page = nil)
      redirect url(:wishes, :show, :id => w || @wish, :page => page)
    end

    def set_collections_for_wish
      @types = Type.all
      @formats = Format.all
      @countries = Country.all
    end 

  # view
  
    def wish_link(w, display_format = nil)
      html_options = {}
      if display_format
        html_options[:class] = case display_format
          when :browse
            'wish'
        end
      end
      link_to w.name, url(:wishes, :show, :id => w), html_options
    end
  
    def wish_additional_info(w)
      s = ''
      if w.format
        s << w.format.description
        previous = true
      end
      if w.country
        s << ' | ' if previous
        s << w.country.description
        previous = true
      end
      if w.year
        s << ' | ' if previous
        s << w.year.to_s
      end
      s.blank? ? nil : content_tag(:span, "[ #{s} ]", :class => 'wish_info')
    end  
end