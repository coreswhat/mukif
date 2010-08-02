
Mukif.helpers do

  # controller
  
    def ensure_report_type_valid
      report_types = ['user', 'torrent', 'comment', 'wish', 'wish_comment', 'topic', 'post'] 
      raise ArgumentError unless report_types.include? params[:type]
    end
  
    def find_report_target
      model_class = params[:type].camelize.constantize
      model_class.find params[:id]
    end
    
    def report_target_url      
      if params[:type] == 'topic'
        url(:topics, :show, :forum_id => @target.forum_id, :id => @target)
      else
        url(params[:type].pluralize.to_sym, :show, :id => @target)
      end
    end
end