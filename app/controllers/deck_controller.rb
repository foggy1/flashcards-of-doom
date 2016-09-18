get '/decks' do
  @decks = Deck.all
  erb :'decks/index'
end

get '/decks/:deck_id/rounds/new' do
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
  guess = Guess.new(response: params[:response], card_id: @card.id)
  if guess.save
    current_round.guesses << guess
    redirect "/rounds/#{current_round.id}/cards/#{@card.id}/answer"
  else
    @errors = guess.errors.full_messages
    @card = Card.find(params[:id])
    @deck = @card.deck
    erb :'cards/show'
  end
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

post '/rounds/:round_id/cards/:id/next' do
  @card = Card.find(params[:id])
  card_index = session[:shuffled_deck_ids].index(@card.id)
  if card_index + 1 >= shuffled_deck_ids.length
    session[:shuffled_deck_ids] -= session[:correct_cards]
    redirect "/rounds/#{current_round.id}/round_stats" if session[:shuffled_deck_ids].length == 0
    next_card_id = Card.find_by(id: session[:shuffled_deck_ids].first).id
  else
    next_card_id = session[:shuffled_deck_ids][card_index+1]
  end 
  redirect "rounds/#{current_round.id}/cards/#{next_card_id}" 
end

get '/rounds/:round_id/round_stats' do
  @round = Round.find(params[:round_id])
  @deck = @round.deck
  @guess_ids = @round.guesses.map(&:card_id)
  @correct_guesses = @guess_ids.select { |id| @guess_ids.count(id) == 1 }
  erb :'rounds/stats'
end
