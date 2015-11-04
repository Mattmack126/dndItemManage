require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/character'
require_relative 'models/campaign'
require_relative 'models/item'
require_relative 'models/user'
require_relative 'models/campaignUser'
enable :sessions
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
  def logged_in?
    !!current_user
  end
end
after do
  ActiveRecord::Base.connection.close
end
get '/' do
  @user_campaigns = Campaignuser.where(user_id: current_user)
  erb :CampaignIndex
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~Campaign~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#New Campaign~~~~~~~~~~~~~~~~~~~~~
get '/campaign/new' do
  erb :'campaign/new'
end
#New campaign form
post '/campaign' do
  new_campaign = Campaign.new(name:params[:campaign_name],description:params[:campaign_description],isactive:params[:campaign_description],
                              gold:'10',silver:'10',copper:'10')
  new_campaign.save
  new_campaign = Campaign.last
  campaignAssign = Campaignuser.new(user_id:current_user.id,campaign_id:new_campaign.id,isowner:'true')
  campaignAssign.save
  redirect to "/campaign/#{new_campaign.id}"
end
# Display a campaign~~~~~~~~~~~~~~
get '/campaign/:id' do
  @campaign = Campaign.find(params[:id])
  @characters = Character.where(campaign_id:params[:id])

  erb :'campaign/show'
end
#Edit a campaign~~~~~~~~~~~~~~~~~~
get '/campaign/:id/edit' do
  @campaign = Campaign.find(params[:id])
  erb :'campaign/edit'
end
# Edit a campaign Form
put '/campaign/:id' do
  update_campaign = Campaign.find(params['id'])
  update_campaign.name = params[:campaign_name]
  update_campaign.description = params[:campaign_description]
  update_campaign.isactive = params[:isActive]
  update_campaign.gold = params[:campaign_gold]
  update_campaign.silver = params[:campaign_silver]
  update_campaign.copper = params[:campaign_copper]
  update_campaign.save
  redirect to "/campaign/#{params[:id]}"
end
# Delete a campaign~~~~~~~~~~~~~~~~
delete '/campaign/:id' do
  Campaign.find(params[:id]).destroy
  Campaignuser.where(campaign_id:params[:id]).destroy_all
  redirect to "/"
end


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~Character~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# New Character ~~~~~~~~~~~~~~~~~~~
get '/campaign/:id/character/new' do
  @campaign = Campaign.find(params[:id])
  erb :'character/new'

end

# New Character form ~~~~~~~~~~~~~~
  post '/character/:id' do
  new_character = Character.new(name:params[:character_name],job:params[:character_class],level:params[:character_level],
    isalive:'true',user_id:current_user.id,campaign_id:params['id'],gold:'0',silver:'0',copper:'0')
  new_character.save
  redirect to "/campaign/#{params['id']}"
end


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~Authentication~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#show login form
get "/login" do
  erb :login
end
#creating a session
post "/session" do
  user = User.find_by({username: params[:username]})
  if user && user.authenticate(params[:password])
    #yay
    session[:user_id] = user.id
    #redirect user
    redirect to '/'
  else
    #nay
    #redirect user
    redirect to '/login'
  end
end
delete '/session' do
  session[:user_id] = nil
  redirect to "/login"
end
