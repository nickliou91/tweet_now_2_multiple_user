class CreateTwitterUsers < ActiveRecord::Migration
  def change
  	create_table :twitter_users do |t|
  		t.string :username
  		t.text :consumer_key
  		t.text :consumer_secret_key
  		t.text :access_token
  		t.text :secret_access_token
  		t.timestamps
  	end
  end
end
