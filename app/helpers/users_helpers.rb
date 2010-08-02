
Mukif.helpers do
  
  # controller    
      
    def redirect_to_user(u = nil)
      redirect url(:users, :show, :id => u || @user)
    end

    def set_collections_for_user
      @genders = Gender.all
      @countries = Country.all
      @styles = Style.all
    end
    
  # view
  
    def user_link(u, include_stats = false)
      if u
        html_options = {}
        html_options[:class] = u.role.css_class
        unless u.active?
          html_options[:class] << ' user_inactive'
          html_options[:title] = t('h.app_helper.user_link.inactive')
        else          
          if include_stats
            html_options[:title] = "up: #{textual_data_amount u.uploaded} | down: #{textual_data_amount u.downloaded} | ratio: #{number_to_ratio u.ratio}"
          else
            html_options[:title] = u.role.description
          end
        end
        link_to u.username, url(:users, :show, :id => u), html_options
      end
    end   
end