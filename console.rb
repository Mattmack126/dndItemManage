require 'active_record'
require 'pry'
require 'ffaker'


#This will show the sql in the terminal
ActiveRecord::Base.logger = Logger.new(STDERR)

require_relative 'db_config'
require_relative 'models/character'
require_relative 'models/campaign'
require_relative 'models/item'
require_relative 'models/user'
require_relative 'models/campaignUser'

binding.pry