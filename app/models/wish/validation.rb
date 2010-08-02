
class Wish < ActiveRecord::Base

  # validation concern
  
  def validate
    validate_name
    validate_year
    validate_counters
  end  
  
  private
  
    def validate_name
      if self.name.blank?
        add_error :name, 'required'
      end
    end
      
    def validate_year
      if !self.year.blank? && self.year.to_s !~ /\d{4}/
        add_error :year, 'invalid'
      end
    end  
        
    def validate_counters
      raise 'wish total_bounty cannot be negative!' if self.total_bounty < 0
    end    
end
