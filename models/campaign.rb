class Campaign <ActiveRecord::Base
  has_many :characters
  has_many :items
  belongs_to :campaignuser
end