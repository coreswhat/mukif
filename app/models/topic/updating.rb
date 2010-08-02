
class Topic < ActiveRecord::Base

  # updating concern

  def editable_by?(user)
    user.id == self.user_id || user.admin_mod?
  end

  def update_with_updater(params, updater)
    @update_fulltext = (self.title != params[:title]) || (self.body != params[:body])
     
    self.title = params[:title]
    self.body = params[:body]
    self.edited_at = Time.now
    self.edited_by = updater.username
    save
  end
  
  def update_attributes(params)
    raise 'use update_with_updater instead!'  
  end
end