class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations
  has_many :participants, through: :registrations, source: :user
  has_one :chatroom, dependent: :destroy

  validates :name, presence: true
  validates :location, presence: true
  validates :registration_start, presence: true
  validates :registration_end, presence: true
  validates :event_start, presence: true
  validates :event_end, presence: true
  validates :short_desc, presence: true
  validates :long_desc, presence: true
  validate :register_end_before_event_start, :event_start_before_event_end

  default_scope { order(:event_start) }
  scope :available_registration?, -> { where('registration_end > ?', DateTime.now) }
  scope :active?, -> { where('event_end > ?', DateTime.now) }
  scope :inactive?, -> { where('event_end < ?', DateTime.now) }

  def registerable?
    registration_start < DateTime.now && registration_end > DateTime.now
  end

  def register_end_before_event_start
    unless registration_start.nil? || registration_end.nil? || event_start.nil?
      unless registration_start < registration_end && registration_end < event_start
        errors.add(:registration_end, "Must be between registration start and event start")
      end
    end
  end

  def event_start_before_event_end
    unless event_start.nil? || event_end.nil?
      unless event_start < event_end
        errors.add(:event_start, "Must be before event end")
      end
    end
  end
end
