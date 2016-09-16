class Card < ActiveRecord::Base
  belongs_to :deck
  has_many :guesses

  validates :question, presence: true
  validates :answer, presence: true
end
