
Mukif.helpers do

  # view
    
    def type_label(t, params = nil, link = false)      
      text = t.image ? image_tag(t.image, :class => 'torrent_type', :alt => t.description, :title => t.description) : t.description
      if link && params
        link_params = params.dup
        link_params.delete_if {|k, v| v.blank? } # just to clean the link
        link_params[:type_id] = t.id
        link_to text, link_params
      else
        text
      end    
    end
end