class Deck < ActiveRecord::Base
  attr_accessor :current_card_index, :shuffled_deck
  has_many :rounds
  has_many :cards
  has_many :users, through: :rounds

  validates :title, presence: true, uniqueness: true

  def shuffle_deck
    @shuffled_deck = self.cards.shuffle
  end

  # def shuffled_deck
  #   @shuffled_deck
  # end

  def next_card
    self.current_card_index += 1
  end

  def current_card_index
    @current_card_index ||= 0
  end

  def purge
    self.shuffled_deck = self.shuffled_deck.reject(&:done?)
  end

  def end_of_deck?
    self.current_card_index >= self.shuffled_deck.length
  end

  def start_over
    @current_card_index = 0
  end

  # def current_card_index=(new_card_index)
  #   @current_card_index = new_card_index
  # end

end
