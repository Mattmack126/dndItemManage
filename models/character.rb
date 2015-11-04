class Character < ActiveRecord::Base
  has_many :items 
  has_one :campaign
end