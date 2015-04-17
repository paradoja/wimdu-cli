require "thor"

require 'active_record'
require 'sqlite3'
require 'logger'

ActiveRecord::Base.logger = Logger.new(File.join 'logs', 'debug.log')
configuration = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(configuration['production'])

module Wimdu
  class App < Thor
    desc "new", "Add a new property"
    def new
      $stdout.puts "Starting with new property ABC1DEF2."
      $stdout.print "Title: "
      $stdout.flush # Aruba seems to require this
      $stdin.gets
      $stdout.puts "Address: "
    end
  end
end
