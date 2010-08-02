
Mukif.helpers do

  # view
  
    def table_header_css_class(column_name)
      if params[:order_by] == column_name 
        settings.c[:browse][:header_order_by_css_class] 
      else
        settings.c[:browse][:header_css_class]
      end
    end
  
    def table_header_link(text, column_name, collection)
      unless collection.blank?      
        link_params = params.dup.symbolize_keys!
        
        if column_name == params[:order_by]
          desc = true unless params[:desc] == '1'
        else
          if collection && !collection.default_desc.blank?
            desc = true if collection.default_desc.include? column_name
          end
        end
        link_params[:desc] = desc ? '1' : nil
        link_params[:order_by] = column_name      
        link_params[:page] = nil if params[:page] == '1' # just cosmetic
        link_params.delete_if {|k, v| v.blank? }         # just cosmetic    
        
        url = url(collection.controller, collection.action, link_params)
        
        content_tag :a, text, :href => url, :class => settings.c[:browse][:header_link_css_class]
      else
        text  
      end 
    end
end