
class User < ActiveRecord::Base

  # logging concern

  private

    def add_log(key, args)
      Log.kreate! I18n.t(key, args)
    end

    def log_destruction(destroyer)
      add_log('m.user.log_destruction.log', :username => self.username, :by => destroyer.username)
    end
end