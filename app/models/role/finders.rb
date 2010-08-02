
class Role < ActiveRecord::Base

  # finders concern

  def self.all_for_search
    find(:all).delete_if {|r| r.system? }
  end

  def self.all_for_user_edition(user, editor)
    raise 'editor must be at least admin to edit other users role' unless editor.admin?

    if user
      if editor == user
        [ editor.role ] # user cannot change its own role so return just users role
      else 
        case
          when editor.system?
            find(:all).delete_if {|r| r.system? }
          when editor.owner?
            find(:all).delete_if {|r| r.system? || r.owner? }
          when editor.admin?
            find(:all).delete_if {|r| r.reserved? }
        end
      end
    end
  end
end