class Card < ActiveRecord::Base
  attr_accessor :done

  belongs_to :deck
  has_many :guesses

  validates :question, presence: true
  validates :answer, presence: true

  def guessed_correctly?
    self.guesses.last.response == self.answer
  end

  def take_it_out
    @done = true 
  end

  def done?
    @done ||= false
  end


end
