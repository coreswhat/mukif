
class Wish < ActiveRecord::Base

  # updating concern

  def editable_by?(user)
    unless user.admin_mod?
      open? && user.id == self.user_id
    else
      true
    end
  end

  def update_with_updater(params, updater)
    set_attributes params
    save
  end
  
  def update_attributes(params)
    raise 'use update_with_updater instead!'  
  end  

  private

    def set_attributes(params)
      @update_fulltext = (self.name != params[:name]) || (self.description != params[:description])  

      self.name = params[:name]
      self.type_id = params[:type_id]
      self.format_id = params[:format_id]
      self.description = params[:description]
      self.year = params[:year]
      self.country_id = params[:country_id]
    end
end