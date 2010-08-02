
class BgTask < ActiveRecord::Base

  # logging concern

  def log_exec!(status = nil, begin_at = nil, end_at = nil)
    self.class.log_exec! self.name, status, begin_at, end_at, self.next_exec_after
  end

  def self.log_error!(e, bg_task_name)
    message = "Task: #{bg_task_name}\n Error: #{e.class}\n Message: #{e.clean_message}"
    location = e.backtrace[0, 15].join("\n")
    ErrorLog.kreate! message, location
  end

  def self.log_exec!(bg_task_name, status = nil, begin_at = nil, end_at = nil, next_at = nil)
    BgTaskLog.kreate! bg_task_name, begin_at, end_at, next_at, status
  end
  
  private

    def self.app_log(text, admin = false)
      Log.kreate! text, admin
    end  
end