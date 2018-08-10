class Chatroom < ApplicationRecord
  belongs_to :event
  has_many :messages, dependent: :destroy
  has_many :participants, through: :event  
  
  validates :event_id, presence: true
end
