require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'dndloot'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)