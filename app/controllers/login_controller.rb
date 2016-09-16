get 'users/login' do
  erb :'login'
end
# check erb rout

post 'users/login' do
  user = User.find_by(username: params[:username])
  user ||= User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "Invalid login, please try again."
    erb :'login'
  end
end
