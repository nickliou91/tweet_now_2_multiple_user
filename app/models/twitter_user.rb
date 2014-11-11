class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!

  # attr_reader :user_info
  def self.find_or_created_by_username(twitter_user)

  	 # user_info = {username: twitter_user.info.name, nickname: twitter_user.info.nickname, profile_image_link:twitter_user.info.image, follower_count:twitter_user.extra.raw_info.followers_count, friend_count:twitter_user.extra.raw_info.friends_count, statues_count: twitter_user.extra.raw_info.statuses_count  }
  	
  	if TwitterUser.exists?(username: twitter_user.info.nickname)
  		user = TwitterUser.find_by(username: twitter_user.info.nickname)
  		user.update(access_token: twitter_user.extra.access_token.token, secret_access_token: twitter_user.extra.access_token.secret)
  		return user 
  	else
  		TwitterUser.create(username: twitter_user.info.nickname, access_token: twitter_user.extra.access_token.token, secret_access_token: twitter_user.extra.access_token.secret)
		end  		

  end 

  def self.fetch_user_info!(omniauth)
  
 
   # @user_name = @@auth['info']['name']
   # @nickname = @@auth['info']['nickname']
   # @profile_image_link = @@auth['info']['image']
   # @follower_count = @@auth['extra']['raw_info']['followers_count']   
   # @friend_count = @@auth['extra']['raw_info']['friends_count']
   # @statues_count = @@auth['extra']['raw_info']['statuses_count']

  end

  def fetch_tweets!
  	client.user_timeline(self.username)
  end 

  def post_tweet!(tweet_message)
  	client.update(tweet_message)

  end



  private 
  def client 
  	Twitter::REST::Client.new do |config|
  		config.consumer_key = API_KEYS["development"]["twitter_api_key_id"]
  		config.consumer_secret = API_KEYS["development"]["twitter_secret_key_id"]
  		config.access_token = self.access_token
  		config.access_token_secret = self.secret_access_token
  	end
  	
  end 

end
