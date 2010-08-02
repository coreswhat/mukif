
class Forum < ActiveRecord::Base

  # updating concern

  def editable_by?(user)
    user.admin?
  end
end