
class Wish < ActiveRecord::Base

  # notification concern

  private

    def deliver_notification(user, subject_key, body_key, body_args = {})
      s = I18n.t(subject_key)
      b = I18n.t(body_key, body_args)
      Message.deliver_system_message! user, s, b
    end

    def notify_approval
      # notify user who filled the wish
      deliver_notification(self.filler,
                           'm.wish.notify_approval.filler_subject',
                           self.total_bounty > 0 ? 'm.wish.notify_approval.filler_body_with_amount' : 'm.wish.notify_approval.filler_body',
                           :id => self.id, :name => self.name)

      # notify user who created the wish
      deliver_notification(self.user,
                           'm.wish.notify_approval.wisher_subject',
                           'm.wish.notify_approval.wisher_body',
                           :id => self.id, :name => self.name)

      # notify users who have not revoked bounties for the wish
      unless self.wish_bounties.blank?
        self.wish_bounties.each do |wb|
          next if wb.revoked?
          if wb.user != self.user && wb.user != self.filler
            deliver_notification(wb.user,
                                 'm.wish.notify_approval.bounter_subject',
                                 'm.wish.notify_approval.bounter_body',
                                 :id => self.id, :name => self.name)
          end
        end
      end
    end

    def notify_rejection(rejecter, reason)
      deliver_notification(self.filler,
                           'm.wish.notify_rejection.subject',
                           'm.wish.notify_rejection.body',
                           :id => self.id, :name => self.name, :rejecter_id => rejecter.id, :rejecter => rejecter.username, :reason => reason)
    end

    def notify_destruction(destroyer, reason)
      deliver_notification(self.user,
                           'm.wish.notify_destruction.subject',
                           'm.wish.notify_destruction.body',
                            :name => self.name, :destroyer_id => destroyer.id, :destroyer => destroyer.username, :reason => reason)
    end
end