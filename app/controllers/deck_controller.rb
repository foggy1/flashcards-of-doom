get '/decks' do
  @decks = Deck.all
  erb :'decks/index'
end

get '/decks/:deck_id/rounds/new' do
    session[:round] = Round.create
    deck = Deck.find(params[:deck_id]).rounds << session[:round]
    current_user.rounds << session[:round]
    deck.shuffle_deck
    card_to_view = deck.shuffled_deck[deck.current_card_index].id
    redirect "/rounds/#{session[:round].id}/card/#{card_to_view}"
end

before 'rounds/:round_id/card/:id' do
  @card = Card.find(params[:id])
  deck = @card.deck
  if deck.end_of_deck?
    deck.purge
    deck.start_over
  end
end

get 'rounds/:round_id/card/:id' do
  @card = Card.find(params[:id])
  erb :'card/show'
end

post 'rounds/:round_id/card/:id' do
  @card = Card.find(params[:id])
  guess = Guess.create(response: params[:response], card_id: @card.id)
  session[:round].guesses << guess
  redirect "/rounds/#{session[round].id}/card/#{@card.id}/answer"
end

get 'rounds/:round_id/card/:id/answer' do
  @card = Card.find(params[:id])
  if @card.guessed_correctly?
    @message = "Correct!"
    @card.take_it_out
  else
    @message = "Wrong, the correct answer is #{@card.answer}!"
  end
  erb :'/card/answer'
end

post 'rounds/:round_id/card/:id/next' do
  @card = Card.find(params[:id])
  deck = @card.deck
  deck.next_card
  card_to_view = deck.shuffled_deck[deck.current_card_index].id
  redirect "rounds/#{session[:round].id}/card/#{card_to_view}"
end
