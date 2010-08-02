
module ErrorHandling
  
  module Helpers
    
    # 404
    
      def handle_not_found
        logger.debug ':-o error_handling.handle_not_found'  
        render_error_page 'not_found'
      end
    
    # 405
    
      def handle_method_not_allowed
        logger.debug ':-o error_handling.handle_method_not_allowed'  
        render_error_page 'method_not_allowed'
      end  
  
    # exception
    
      def handle_exception(e)
        logger.debug ':-o error_handling.handle_exception'  
  
        case e
          when ArgumentError, ActiveRecord::RecordNotFound
            template = 'invalid_request'
          when Authorization::AccessDeniedError, Message::NotOwnerError
            template = 'access_denied'
          else
            template, force_log = 'unexpected', true
        end
        
        log_error e, force_log
        
        render_error_page template
      end
  
    # error logging
    
      def log_error(e, force = false)
        ErrorLog.kreate_with_error!(e, current_user) if Padrino.env != 'production' || force
      end
    
    # error page
      
      def render_error_page(template)
        if current_user
          render "error/#{template}"
        else
          redirect 'error.html' # public dir
        end
      end
  end
end
