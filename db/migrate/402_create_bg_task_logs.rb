
class CreateBgTaskLogs < ActiveRecord::Migration

  def self.up
    create_table :bg_task_logs do |t|
      t.column :created_at, :datetime, :null => false
      t.column :bg_task_name, :string, :null => false
      t.column :status, :string
      t.column :exec_begin_at, :datetime
      t.column :exec_end_at, :datetime
      t.column :next_exec_after, :datetime      
    end
  end

  def self.down
    drop_table :bg_task_logs
  end
end
