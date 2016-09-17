get '/decks' do
  @decks = Deck.all
  erb :'decks/index'
end

get '/decks/:deck_id/rounds/new' do
    # session[:round_id] = nil
    # session[:deck] = nil
    round = Round.create
    session[:round_id] = round.id
    session[:deck_id] = params[:deck_id]
    current_deck.rounds << current_round
    current_user.rounds << current_round
    current_deck.shuffle_deck
    card_to_view = current_deck.shuffled_deck[current_deck.current_card_index].id
    redirect "/rounds/#{current_round.id}/card/#{card_to_view}"
end

before '/rounds/:round_id/card/:id' do
  @card = Card.find(params[:id])
  if current_deck.end_of_deck?
    current_deck.purge
    current_deck.start_over
  end
end

get '/rounds/:round_id/card/:id' do
  @card = Card.find(params[:id])
  erb :'card/show'
end

post '/rounds/:round_id/card/:id' do
  @card = Card.find(params[:id])
  guess = Guess.create(response: params[:response], card_id: @card.id)
  session[:round].guesses << guess
  redirect "/rounds/#{session[round].id}/card/#{@card.id}/answer"
end

get '/rounds/:round_id/card/:id/answer' do
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
