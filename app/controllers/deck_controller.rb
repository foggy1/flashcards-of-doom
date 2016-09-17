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
    session[:shuffled_deck_ids] = get_shuffled_ids
    session[:correct_cards] = []
    first_card_to_view = Card.find_by(id: shuffled_deck_ids.first)
    redirect "/rounds/#{current_round.id}/cards/#{first_card_to_view.id}"
end

before '/rounds/:round_id/cards/:id' do
end

get '/rounds/:round_id/cards/:id' do
  @card = Card.find(params[:id])
  @deck = @card.deck
  erb :'cards/show'
end

post '/rounds/:round_id/cards/:id' do
  @card = Card.find(params[:id])
  guess = Guess.create(response: params[:response], card_id: @card.id)
  session[:round].guesses << guess
  redirect "/rounds/#{session[round].id}/cards/#{@card.id}/answer"
end

get '/rounds/:round_id/cards/:id/answer' do
  @card = Card.find(params[:id])
  if @card.guessed_correctly?
    @message = "Correct!"
    session[:correct_cards] << @card.id
  else
    @message = "Wrong, the correct answer is #{@card.answer}!"
  end
  erb :'/cards/answer'
end

post 'rounds/:round_id/card/:id/next' do
  @card = Card.find(params[:id])
  deck = @card.deck
  deck.next_card
  card_to_view = deck.shuffled_deck[deck.current_card_index].id
  # get index of of the id of the current card
  # find card id that is at the next index
  # feed to path

  card_index = session[:shuffled_deck_ids].index(@card.id)
  if card_index + 1 >= shuffled_deck_ids.length
    shuffled_deck_ids -= session[:correct_cards]
    next_card_id = Card.find_by(id: shuffled_deck_ids.first)
  else
    next_card_id = session[:shuffled_deck_ids][card_index+1]
  end 
    redirect "rounds/#{session[:round].id}/cards/#{next_card_id}" 
end
