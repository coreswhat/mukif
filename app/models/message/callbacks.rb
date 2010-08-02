
class Message < ActiveRecord::Base

  # callbacks concern

  before_create :set_default_subject, :trim_body

  private

    def set_default_subject
      self.subject = self.subject.blank? ? I18n.t('m.message.before_create.default_subject') : self.subject[0, 50]
    end

    def trim_body
      self.body = self.body[0, 2000] if self.body
    end
end
