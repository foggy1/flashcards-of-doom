class User < ActiveRecord::Base
  has_many :rounds
  has_many :decks, through: :rounds
  has_many :guesses, through: :rounds

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

end
