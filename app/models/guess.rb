class Guess < ActiveRecord::Base
  belongs_to :card
  belongs_to :round
  has_one :user, through: :rounds

  validates :response, presence: true
end
