
Mukif.helpers do

  # controller
    
    def parse_reward_amount
      unless params[:reward_amount].blank?
        begin
          a = Integer(params[:reward_amount])
        rescue
          return nil
        end
    
        t = case params[:reward_unit] 
          when 'MB'
            a.megabytes
          when 'GB'
            a.gigabytes
          else
            raise ArgumentError, 'invalid reward unit!'
        end
      end
      t
    end
end