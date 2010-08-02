
class Torrent < ActiveRecord::Base

  # logging concern

  private

    def add_log(key, args)
      Log.kreate! I18n.t(key, args)
    end

    def log_creation
      if self.user
        add_log('m.torrent.log_upload.log', :name => self.name, :by => self.user.username)
      else
        add_log('m.torrent.log_upload.log_anonymous', :name => self.name)
      end
    end

    def log_edition(editor, reason)
      add_log('m.torrent.log_edition.log', :name => self.name, :by => editor.username, :reason => reason)
    end

    def log_inactivation(inactivator, reason)
      add_log('m.torrent.log_inactivation.log', :name => self.name, :by => inactivator.username, :reason => reason)
    end

    def log_activation(activator)
      add_log('m.torrent.log_activation.log', :name => self.name, :by => activator.username)
    end

    def log_destruction(destroyer, reason)
      add_log('m.torrent.log_destruction.log', :name => self.name, :by => destroyer.username, :reason => reason)
    end
end