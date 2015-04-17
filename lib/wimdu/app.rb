require 'thor'
require_relative 'config'
require_relative 'property_manager'

module Wimdu
  class App < Thor
    def initialize(*args)
      @property_manager = PropertyManager.new($stdin, $stdout)
      super(*args)
    end

    desc "new", "Add a new property"
    def new
      @property_manager.add
    end

    desc "list", "List fully added properties"
    def list
      @property_manager.list
    end

    desc "continue", "Continue adding properties"
    def continue(code)
      @property_manager.continue(code)
    end
  end
end
