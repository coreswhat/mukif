
class BgTask < ActiveRecord::Base
  
  attr_protected :name

  has_many :bg_task_params, :dependent => :destroy

  def exec(logger = nil, force = false)
    if active?
      begin_at = Time.now
  
      schedule(logger) unless force
  
      if force || exec_now?
        begin
          BgTask.send(self.name, params_hash) # name of invoked method and task name must match
          
          status = 'OK'
          logger.debug ":-) task #{self.name} successfully executed" if logger
        rescue => e
          status = 'FAILED'
          BgTask.log_error! e, self.name
          logger.debug ":-( task #{self.name} error: #{e.message}" if logger
          raise e if force
        end
        log_exec! status, begin_at, Time.now unless force
      end
    end
  end
    
  def add_param(name, value)
    self.bg_task_params << BgTaskParam.new(:name => name, :yaml => YAML.dump(value))
  end
  
  private
    
    def exec_now?
      @exec_now
    end
  
    def schedule(logger = nil)
      @exec_now = !self.next_exec_after.blank? && self.next_exec_after < Time.now
      
      if @exec_now || self.next_exec_after.blank?
        self.next_exec_after = Time.now + self.interval_minutes.minutes
        logger.debug ":-) task #{self.name} scheduled to execute after #{self.next_exec_after}" if logger
        save!
      end
    end
  
    def params_hash
      @params_hash ||= load_params_hash
    end

    def load_params_hash
      h = {}     
      self.bg_task_params.each {|p| h[p.name.to_sym] = p.value } unless self.bg_task_params.blank?
      h
    end
end
