get '/users/new' do
  erb :'users/new'
end

post '/users' do
  user = User.new(params[:user])
  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    @errors = user.errors.full_messages
    erb :'users/new'
  end
end

get '/users/:id' do
  @user = User.find(params[:id])
  used_decks = @user.decks
  used_deck_ids = used_decks.map(&:id).uniq
  @decks = Deck.find(used_deck_ids)

  erb :'users/show'
end
