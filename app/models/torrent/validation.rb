
class Torrent < ActiveRecord::Base

  # validation concern
  
  def validate
    validate_name
    validate_year
    validate_counters
  end
  
  def validate_on_create
    validate_info_hash
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
      
    def validate_info_hash
      if Torrent.find_by_info_hash(self.info_hash)
        add_error :info_hash, 'taken'      
      end
    end  
        
    def validate_counters
      raise 'torrent rewards_count cannot be negative!' if self.rewards_count < 0
      raise 'torrent seeders_count cannot be negative!' if self.seeders_count < 0
      raise 'torrent leechers_count cannot be negative!' if self.leechers_count < 0
    end
end
