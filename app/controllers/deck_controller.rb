get '/decks' do
  @decks = Deck.all
  erb :'decks/index'
end

get '/decks/:deck_id/rounds/new' do
    require_login
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

