
class Reward < ActiveRecord::Base

  # validation concern
  
  def validate
    validate_amount
  end  
  
  private
  
    def validate_amount
      if self.amount.blank?
        add_error :amount, 'required'
      end
    end   
end