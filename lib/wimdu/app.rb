require 'thor'
require_relative 'serializer'
require_relative 'property_manager'

module Wimdu
  class App < Thor
    desc "new", "Add a new property"
    def new
      PropertyManager.new($stdin, $stdout).add
    end
  end
end
