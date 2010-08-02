
class Report < ActiveRecord::Base

  # callbacks concern

  before_save :trim_reason

  private

    def trim_reason
      self.reason = self.reason[0, 200]
    end
end