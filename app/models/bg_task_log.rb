
class BgTaskLog < ActiveRecord::Base

  def self.all(args)
    find :all, :order => 'created_at DESC', :limit => args[:limit]
  end

  def self.delete_olds(threshold)
    delete_all ['created_at < ?', threshold]
  end
  
  def self.kreate!(bg_task_name, begin_at, end_at, next_at, status)
    create! :bg_task_name => bg_task_name,
            :exec_begin_at => begin_at,
            :exec_end_at => end_at,
            :next_exec_after => next_at,
            :status => status
  end
end
