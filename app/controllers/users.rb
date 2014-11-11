enable :sessions

get '/login' do
	session[:admin]= true
	redirect to("/auth/twitter")

end 

get '/auth/twitter/callback' do
	
	# byebug
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  "You are now logged in"
  "<h1>Hi #{env['omniauth.auth']['info']['name']}!</h1><img src='#{env['omniauth.auth']['info']['image']}'>"

  
   @user = TwitterUser.find_or_created_by_username(env['omniauth.auth'])
  session[:info] = {
  	
  	profile_image_url: env['omniauth.auth']['info']['image'],
  	name: env['omniauth.auth']['info']['name'],
  	nickname: env['omniauth.auth']['info']['nickname'],
  	followers: env['omniauth.auth']['extra']['raw_info']['followers_count'],
  	friends: env['omniauth.auth']['extra']['raw_info']['friends_count'],
  	statuses: env['omniauth.auth']['extra']['raw_info']['statuses_count']
  }
   # @user_name =user_info.name
   # @profile_image_link = user_info.profile_image_url
   # @nickname = user_info.nickname
  
   session[:user_id] = @user.id
   session[:username] = @user.username
   redirect "/home" 
end

get '/auth/failure' do 
	params[:message]

end 

get '/logout' do 
	session[:admin] = nil 
	session[:user_id] = nil
	session[:username] = nil 
	session[:info] = nil 
	"You are now logout!"
	redirect "/"
end 

get '/home' do 
	@user_name = session[:info][:name]
	@nickname = session[:info][:nickname]
	@profile_image_link = session[:info][:profile_image_url]
	@statues_count = session[:info][:statuses]
	@follower_count = session[:info][:followers]
	@friend_count = session[:info][:friends]


	erb :'users/index'
end 

get '/tweet' do
	@user = TwitterUser.find_by(id: session[:user_id])
	@tweets = @user.fetch_tweets!

	 erb :'users/show'
end  

post '/tweet' do 
	
	@user = TwitterUser.find_by(id: session[:user_id])
	@user.post_tweet!(params[:tweet_msg])
	
	redirect '/tweet'

end 


