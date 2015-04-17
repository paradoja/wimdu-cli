require 'active_record'
require 'sqlite3'
require 'logger'
require 'psych'

# init code for the serialization & models

ROOT_DIR = File.join File.dirname(__FILE__), '..', '..'

log_path = File.join 'logs', 'debug.log'
ActiveRecord::Base.logger = Logger.new(log_path) if File.exists? File.dirname(log_path)

configurations = Psych.load(IO.read(File.join ROOT_DIR, 'config', 'database.yml'))
environment = if ENV['WIMDU_ENV'].nil? || ENV['WIMDU_ENV'].empty?
                'production'
              else
                ENV['WIMDU_ENV']
              end
db_configuration = configurations[environment]
ActiveRecord::Base.establish_connection(db_configuration)

# Ensure the correct database is used even in 'strange' environments
current_dir = Dir.pwd
Dir.chdir ROOT_DIR
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{ROOT_DIR}/db/migrate",
                               ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
Dir.chdir current_dir

Dir[File.join ROOT_DIR, 'lib', 'wimdu', 'models' '/**/*.rb'].each(&method(:require))
