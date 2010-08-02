
class User < ActiveRecord::Base

  # ratio policy concern

  def under_ratio_watch?
    defective? && self.ratio_watch_until
  end

  # Put this user under ratio watch until the specified date
  def start_ratio_watch!(watch_until)
    User.transaction do
      self.role = Role.find_by_name(Role::DEFECTIVE)
      self.ratio_watch_until = watch_until
      save!
      notify_ratio_watch
    end
  end

  # End this user ratio watch
  def end_ratio_watch!
    self.role = Role.find_by_name(Role::USER)
    self.ratio_watch_until = nil
    save!
  end
end



