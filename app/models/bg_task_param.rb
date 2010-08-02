
class BgTaskParam < ActiveRecord::Base

  belongs_to :bg_task
  
  def value
    YAML.load(self.yaml)
  end
end
