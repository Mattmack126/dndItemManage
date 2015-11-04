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
  update_campaign.save
  redirect to "/"
end
# Delete a campaign~~~~~~~~~~~~~~~~
delete '/campaign/:id' do
  Campaign.find(params[:id]).destroy
  Campaignuser.where(campaign_id:params[:id]).destroy_all
  redirect to "/"
end
# Add user to a campaign
get '/campaign/new/character' do
  erb :'campaign/newuser'
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
