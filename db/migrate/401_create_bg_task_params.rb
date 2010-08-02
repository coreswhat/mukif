
class CreateBgTaskParams < ActiveRecord::Migration

  def self.up
    create_table :bg_task_params do |t|
      t.column :bg_task_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :yaml, :text, :null => false
    end
  end

  def self.down
    drop_table :bg_task_params
  end
end

