 
module BgTasks

  module Support

    # Retrieve the tasks from the database or load them from the config file.
    def fetch_bg_tasks
      bg_tasks = BgTask.all
      bg_tasks.blank? ? load_bg_tasks : bg_tasks
    end

    def reload_bg_tasks
      BgTask.destroy_all
      load_bg_tasks
    end

    # Load the bg_tasks configuration file and create records in the database
    # for each task and its parameters.
    def load_bg_tasks
      config = open(File.join(Padrino.root('config', 'bg_tasks.yml'))) {|f| YAML.load(f)[Padrino.env.to_s] }
      config.symbolize_keys!

      unless config.blank?
        config.each do |bg_task_name, bg_task_properties|
          bg_task_properties.symbolize_keys!
          
          t = BgTask.new
          t.name = bg_task_name.to_s
          t.interval_minutes = bg_task_properties[:interval_minutes]            
          unless bg_task_properties[:params].blank?
            bg_task_properties[:params].each do |param_name, param_value|
              t.add_param param_name, param_value
            end
          end
          t.save!
        end
      end
      BgTask.all
    end
  end
end






