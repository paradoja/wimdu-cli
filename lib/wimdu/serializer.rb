require 'active_record'
require 'sqlite3'
require 'logger'

# init code for the serialization & models

Dir['./lib/wimdu/models/**/*.rb'].each(&method(:require))

ActiveRecord::Base.logger = Logger.new(File.join 'logs', 'debug.log')
configuration = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(ENV['WIMDU_ENV'] || configuration['production'])
