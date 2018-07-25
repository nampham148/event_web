class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations
  has_many :participants, through: :registrations, source: :user

  default_scope { order(:event_start) }
  scope :available_registration?, -> { where('registration_end > ?', DateTime.now) }
  scope :active?, -> { where('event_end > ?', DateTime.now) }
  scope :inactive?, -> { where('event_end < ?', DateTime.now) }

  def registerable?
    registration_start < DateTime.now && registration_end > DateTime.now
  end
end
