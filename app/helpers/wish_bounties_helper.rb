
Mukif.helpers do

  # controller  
  
    def parse_bounty_amount
      unless params[:bounty_amount].blank?
        begin
          a = Integer(params[:bounty_amount])
        rescue
          return nil
        end
        t = case params[:bounty_unit]
          when 'MB'
            a.megabytes
          when 'GB'
            a.gigabytes
          else
            raise ArgumentError, 'invalid bounty unit!'
        end
      end
      t
    end
end