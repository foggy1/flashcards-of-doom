get '/users/login' do
  erb :'users/login'
end
# check erb rout

post '/users/login' do
  user = User.find_by(username: params[:login])
  user ||= User.find_by(email: params[:login])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "Invalid login, please try again."
    erb :'users/login'
  end
end
