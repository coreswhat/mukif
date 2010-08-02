
module Authorization
  
  class AccessDeniedError < StandardError
  end
  
  def self.registered(app)
    app.helpers Helpers
  end  
end  
  
  

