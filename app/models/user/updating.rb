
class User < ActiveRecord::Base

  # updating concern

  def editable_by?(updater)
    if updater != self && !updater.system?
      if updater.owner?
        return false if system? || owner? # owner can update all but system and owners
      elsif updater.admin?
        return false if admin? # admin can update all but admins and above
      else
        return false # others can update only themselves
      end
    end
    true
  end

  def update_with_updater(params, updater, current_password, update_counters = false)
    if set_attributes(params, updater, current_password, update_counters)
      save # only called if no errors found in set_attributes, as it resets the errors collection
    else
      false
    end        
  end
  
  def update_attributes(params)
    raise 'use update_with_updater instead!'  
  end 

  private  
  
    def set_attributes(params, updater, current_password, update_counters = false)
      unless updater.admin?
        check_required_password_for_update current_password # non admin users must provide password for ANY modification
      else
        set_administration_attributes params, updater, update_counters
      end

      set_new_password_attributes params
      set_new_email_attribute params
      set_regular_attributes params
      
      errors.empty?
    end

    def check_required_password_for_update(password)
      if password.blank?
        add_error :current_password, 'required'
      else
        add_error :current_password, 'incorrect' unless authenticated?(password)
      end            
    end
    
    def set_administration_attributes(params, updater, update_counters)
      
      if self.username != params[:username]
        self.username = params[:username]
        validate_username
      end
      
      if self.role_id != params[:role_id].to_i
        if system?
          errors.add :role_id, 'system cannot be demoted!' # happens only if html form tampered, no need for i18n
        else
          self.role_id = params[:role_id]
          unless role_update_allowed?(params, updater)
            errors.add :role_id, 'forbidden assignment!'# idem
          end
        end
      end
      
      self.extra_tickets = params[:extra_tickets]
      self.active = params[:active] if !system?
      self.staff_info = params[:staff_info]
      self.ratio_watch_until = params[:ratio_watch_until]
      
      if update_counters
        self.uploaded = params[:uploaded]
        self.downloaded = params[:downloaded]
        set_ratio # tracker concern
        validate_counters
      end
    end

    def set_new_password_attributes(params)
      unless params[:password].blank?
        self.password = params[:password]
        self.password_confirmation = params[:password_confirmation]
        validate_password
      end
    end

    def set_new_email_attribute(params)
      if self.email != params[:email]
        self.email = params[:email]
        validate_email
      end
    end

    def set_regular_attributes(params)
      self.country_id = params[:country_id]
      self.style_id = params[:style_id]
      self.gender_id = params[:gender_id]
      self.avatar = params[:avatar]
      self.info = params[:info]
      self.default_types = params[:default_types].blank? ? nil : params[:default_types].join(' ')
      self.save_sent = params[:save_sent]
      self.delete_on_reply = params[:delete_on_reply]
      self.display_last_request_at = params[:display_last_request_at]
      self.display_uploads = params[:display_uploads]
      self.display_snatches = params[:display_snatches]
      self.display_seeding = params[:display_seeding]
      self.display_leeching = params[:display_leeching]
    end

    def role_update_allowed?(params, updater)
      new_role = Role.find_by_id params[:role_id]
      unless new_role
        false
      else
        if updater.system?
          return false if new_role.system?
        elsif updater.owner?
          return false if new_role.owner?
        elsif updater.admin?
          return false if new_role.admin?
        else
          return false
        end
        true
      end
    end
end
