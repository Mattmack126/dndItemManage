class Campaignuser <ActiveRecord::Base
  has_many :users
  has_many :campaigns
end