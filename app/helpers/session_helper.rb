def current_user
  @current_user ||= User.find_by(id: session[:user_id])
end

def current_deck
  @current_deck ||= Deck.find_by(id: session[:deck_id])
end

def current_round
  @current_round ||= Round.find_by(id: session[:round_id])
end


def require_login
  redirect '/login' unless logged_in?
end

def logged_in?
  !!current_user
end
