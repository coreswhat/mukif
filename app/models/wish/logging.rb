
class Wish < ActiveRecord::Base

  # logging concern

  private

    def add_log(key, args)
      Log.kreate! I18n.t(key, args)
    end

    def log_creation
      add_log('m.wish.log_creation.log', :name => self.name, :by => self.user.username)
    end

    def log_approval
      add_log('m.wish.log_approval.log', :name => self.name, :by => self.filler.username)
    end

    def log_destruction(destroyer, reason)
      add_log('m.wish.log_destruction.log', :name => self.name, :by => destroyer.username, :reason => reason)
    end
end