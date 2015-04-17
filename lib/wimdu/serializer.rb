require 'active_record'
require 'sqlite3'
require 'logger'
require 'psych'

# init code for the serialization & models

ROOT_DIR = File.dirname(__FILE__)

Dir[File.join ROOT_DIR, 'lib/wimdu/models/**/*.rb'].each(&method(:require))

log_path = File.join 'logs', 'debug.log'
ActiveRecord::Base.logger = Logger.new(log_path) if File.exists? File.dirname(log_path)

configurations = Psych.load(IO.read(File.join ROOT_DIR, '..', '..', 'config', 'database.yml'))
environment = if ENV['WIMDU_ENV'].nil? || ENV['WIMDU_ENV'].empty?
                'production'
              else
                ENV['WIMDU_ENV']
              end
db_configuration = configurations[environment]
ActiveRecord::Base.establish_connection(db_configuration)
