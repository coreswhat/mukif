
module NavigationHelpers

  def path_to(page_name)

    case page_name

      when /account recovery page/i
        '/forgotten_password'
        
      when /comment details page for comment "(.*)"/i
        "/comments/show/#{find_comment_by_body($1).id}"        

      when /forum details page for forum "(.*)"/i
        "/forums/show/#{find_forum_by_name($1).id}"
      
      when /homepage/i
        '/'

      when /invitations page/i
        '/invitations'

      when /login page/i
        '/login'

      when /message details page for message "(.*)"/i
        "/messages/show/#{find_message_by_subject($1).id}"

      when /messenger page for folder "(.*)"/i
        "/messages/#{$1}"

      when /new message page/i
        '/messages/new'

      when /new wish page/i
        '/wishes/new'

      when /password reset page with recovery code "(.*)"/i
        "/reset_password/#{$1}"

      when /post details page for post "(.*)"/i
        "/posts/show/#{find_post_by_body($1).id}"

      when /signup page with invitation code "(.*)"/i
        "/signup/#{$1}"

      when /signup page without invitation code/i
        '/signup'      

      when /topic details page for topic "(.*)"/i
        "/forums/#{find_topic_by_title($1).forum_id}/topics/show/#{find_topic_by_title($1).id}"

      when /torrent details page for torrent "(.*)"/i
        "/torrents/show/#{find_torrent_by_name($1).id}"

      when /torrent upload page/i
        '/upload'

      when /torrents page/i
        '/torrents'
        
      when /user details page for user "(.*)"/i
        "/users/show/#{find_user_by_username($1).id}"
        
      when /user edition page for user "(.*)"/i
        "/users/edit/#{find_user_by_username($1).id}"        

      when /users page/i
        '/users'
        
      when /wish comment details page for wish comment "(.*)"/i
        "/wish_comments/show/#{find_wish_comment_by_body($1).id}"
        
      when /wish details page for wish "(.*)"/i
        "/wishes/show/#{find_wish_by_name($1).id}"

      when /^wish filling page for wish "(.*)"$/i
        "/wishes/fill/#{find_wish_by_name($1).id}"
      
      when /wishes page/i
        "/wishes"
          
      else
        raise "path to '#{page_name}' not found"
    end
  end
end

World(NavigationHelpers)

