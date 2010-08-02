
class Torrent < ActiveRecord::Base

  # updating concern

  def editable_by?(user)
    user.id == self.user_id || user.admin_mod?
  end

  def update_with_updater(params, updater, reason = '')
    set_attributes params, updater
    if save
      log_edition(updater, reason)
      return true
    end
    false
  end
  
  def update_attributes(params)
    raise 'use update_with_updater instead!'  
  end 

  private

    def set_attributes(params, updater)
      @update_fulltext = (self.name != params[:name]) || (self.description != params[:description])
      
      self.name = params[:name]
      self.type_id = params[:type_id]
      self.format_id = params[:format_id]
      self.source_id = params[:source_id]
      self.description = params[:description]
      self.year = params[:year]
      self.country_id = params[:country_id]
      if updater.admin_mod?
        self.free = params[:free]
        self.free_until = params[:free_until]
      end
    end
end