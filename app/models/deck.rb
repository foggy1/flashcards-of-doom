class Deck < ActiveRecord::Base
  has_many :rounds
  has_many :cards
  has_many :users, through: :rounds

  validates :title, presence: true, uniqueness: true
end
