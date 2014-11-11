configure do
  enable :sessions
end

def admin?
	session[:admin]
end 


def login?
	if session[:user_id].nil?
		return false
	else
		return true
	end 
end 


 
 def username
 	TwitterUser.find_by(id: session[:user_id]).username
 end 