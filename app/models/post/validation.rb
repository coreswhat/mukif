
class Post < ActiveRecord::Base

  # validation concern
  
  def validate
    validate_body
  end  
  
  private
  
    def validate_body
      if self.body.blank?
        add_error :body, 'required'
      end
    end   
end