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
  new_campaign = Campaign.new(name:params[:campaign_name],description:params[:campaign_description],isactive:params[:isActive],
                              gold:'10',silver:'10',copper:'10',owner_id:current_user.id)
  new_campaign.save
  new_campaign = Campaign.last
  campaignAssign = Campaignuser.new(user_id:current_user.id,campaign_id:new_campaign.id,isowner:'true')
  campaignAssign.save
  redirect to "/campaign/#{new_campaign.id}"
end
# Show a campaign~~~~~~~~~~~~~~
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
  update_campaign.save
  redirect to "/campaign/#{params[:id]}"
end
# Delete a campaign~~~~~~~~~~~~~~~~
delete '/campaign/:id' do
  Campaign.find(params[:id]).destroy
  Campaignuser.where(campaign_id:params[:id]).destroy_all
  redirect to "/"
end

# Update campaign money ~~~~~~~~~~~
put '/campaign/:id/money' do
  update_money = Campaign.find(params[:id])
  update_money.gold = params[:campaign_gold]
  update_money.silver = params[:campaign_silver]
  update_money.copper = params[:campaign_copper]
  update_money.save
  redirect to "campaign/#{update_money.id}"
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

# edit Character ~~~~~~~~~~~~~~~~~~~
get '/character/:id/edit' do
  @character = Character.find(params[:id])
  erb :'character/edit'

end

# edit Character form ~~~~~~~~~~~~~~
  put '/character/:id' do
    update_character = Character.find(params[:id])
  update_character.name = params[:character_name]
  update_character.job = params[:character_class]
  update_character.level = params[:character_level]
  update_character.save
  redirect to "/character/#{update_character.id}"
end

# Show character ~~~~~~~~~~~~~~~~~~
get '/character/:id' do
  @character = Character.find(params[:id])
  @items = Item.where(character_id:(params[:id]))

  erb :'character/show'
end

# Delete a character~~~~~~~~~~~~~~~~
delete '/character/:id' do
  tempStore = Character.find(params[:id])

  Character.find(params[:id]).destroy
  redirect to "/campaign/#{tempStore.campaign_id}"
end

# Update character money ~~~~~~~~~~~
put '/character/:id/money' do
  update_money = Character.find(params[:id])
  update_money.gold = params[:character_gold]
  update_money.silver = params[:character_silver]
  update_money.copper = params[:character_copper]
  update_money.save
  redirect to "character/#{update_money.id}"
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~Item~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


get '/character/:id/item/new' do
  @character = Character.find(params[:id])
  erb :'item/new'

end

# New Item form ~~~~~~~~~~~~~~
  post '/item/:id' do
    tempCharacter = Character.find(params[:id])
  new_item = Item.new
  new_item.name = params[:item_name]
  new_item.description = params[:item_description]
  new_item.weight = params[:item_weight]
  new_item.gold = params[:item_gold]
  new_item.silver = params[:item_silver]
  new_item.copper = params[:item_copper]
  new_item.quantity = params[:item_quantity]
  new_item.character_id = tempCharacter.id
  new_item.campaign_id = tempCharacter.campaign_id
  new_item.save
  redirect to "/character/#{params['id']}"
end

# Edit Item ~~~~~~~~~~~~~~~~~~~
get '/item/:id/edit' do
  @item = Item.find(params[:id])
  erb :'item/edit'

end

# Edit Item form ~~~~~~~~~~~~~~
  put '/item/:id' do
    update_item = Item.find(params[:id])
  update_item.name = params[:item_name]
  update_item.description = params[:item_description]
  update_item.weight = params[:item_weight]
  update_item.gold = params[:item_gold]
  update_item.silver = params[:item_silver]
  update_item.copper = params[:item_copper]
  update_item.quantity = params[:item_quantity]
  update_item.save
  redirect to "/character/#{update_item.character_id}"
end


delete '/item/:id' do
  tempStore = Item.find(params[:id])
  Item.find(params[:id]).destroy
  redirect to "/character/#{tempStore.character_id}"
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
