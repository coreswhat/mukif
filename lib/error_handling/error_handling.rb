
module ErrorHandling
  
  def self.registered(app)
    app.helpers Helpers
        
    app.set :raise_errors, false
    app.set :show_exceptions, false
    
    app.error 404 do
      handle_not_found
    end
    
    app.error 405 do
      handle_method_not_allowed
    end
     
    app.error ::Exception do
      handle_exception env['sinatra.error']
    end
  end
end
