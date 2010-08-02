
class Peer < ActiveRecord::Base

  # callbacks concern

  after_destroy :after_destroy_routine

  private
  
    def after_destroy_routine
      t = self.torrent.lock!
      t.decrement(seeder? ? :seeders_count : :leechers_count)
      t.save!
    end
end