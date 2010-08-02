
class Report < ActiveRecord::Base

  belongs_to :reporter, :class_name => 'User'
  belongs_to :handler, :class_name => 'User', :foreign_key => 'handler_id'

  def self.kreate!(target, reporter, reason, target_path)
    create! :target_label => make_target_label(target),
            :target_path => target_path,
            :reporter => reporter,
            :reason => reason
  end

  def self.make_target_label(obj)
    "#{obj.class.name.underscore} [#{obj.id}]" # e.g. 'torrent [1]'
  end
end
