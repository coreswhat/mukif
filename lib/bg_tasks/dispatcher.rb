 
module BgTasks
  
  class Dispatcher
    include Support

    def self.exec(logger = nil)
      new.exec_all logger
    end

    def exec_all(logger = nil)
      begin
        bg_tasks = fetch_bg_tasks
        unless bg_tasks.blank?
          log_dispatcher_exec
          bg_tasks.each {|t| t.exec(logger) }
        else
          log_dispatcher_exec 'NO TASKS FOUND!'
        end
      rescue => e
        BgTask.log_error! e, 'BgTasks::Dispatcher'
      end
    end
    
    private
    
      def log_dispatcher_exec(status = nil)
        BgTask.log_exec! 'dispatcher', status
      end
  end
end












