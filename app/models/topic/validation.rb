
class Topic < ActiveRecord::Base

  # validation concern
  
  def validate
    validate_title
    validate_body
  end  
  
  private
  
    def validate_title
      if self.title.blank?
        add_error :title, 'required'
      end
    end 
  
    def validate_body
      if self.body.blank?
        add_error :body, 'required'
      end
    end   
end