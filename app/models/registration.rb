class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :user_id, presence: true
  validates :event_id, presence: true

  validate :registered_events_within_bound
  validate :no_time_conflict
  validate :event_registerable

  private
    def registered_events_within_bound
      errors.add(:event_count, "Too high") if user.active_event_count > 2
    end

    def no_time_conflict
      user.registered_events.active?.each do |user_event|
        if user_event.event_end.between?(event.event_start, event.event_end) || event.event_end.between?(user_event.event_start, user_event.event_end)
          errors.add(:time, "conflicted")
          return
        end
      end
    end

    def event_registerable
      errors.add(:time, "not in range") if !event.registerable?
    end
end
