require 'thor'
require_relative 'serializer'

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
