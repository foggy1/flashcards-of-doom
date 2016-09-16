def current_user
  User.find_by(id: session[:user_id])
end


def require_login
  redirect '/login' unless logged_in?
end

def logged_in?
  !!current_user
end
