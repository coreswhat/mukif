
class Report < ActiveRecord::Base

  # moderation concern
  
  def assign_to!(user)
    self.handler = user
    save!
  end

  def unassign!
    self.handler = nil
    save!
  end
end