
module Authentication
  
  def self.registered(app)
    app.helpers Helpers    
    app.enable :sessions
  end
end



