
class Wish < ActiveRecord::Base

  # callbacks concern

  before_save :trim_description
  
  after_create :create_fulltext!, :log_creation
  
  after_update :update_fulltext!

  private

    def create_fulltext!
      WishFulltext.create! :wish => self, :name => self.name, :description => self.description
    end

    def update_fulltext!
      if @update_fulltext
        self.wish_fulltext.name = self.name
        self.wish_fulltext.description = self.description
        self.wish_fulltext.save!
      end 
    end

    def trim_description
      self.description = self.description[0, 10000] if self.description
    end
end