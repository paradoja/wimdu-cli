module Wimdu
  class PropertyManager
    def initialize(io_in, io_out)
      self.stdin = io_in
      self.stdout = io_out
    end

    def add
      stdout.puts "Starting with new property ABC1DEF2."
      property = Property.new(code: "ABC1DEF2")
      PROPERTY_METHODS.each do |field, text|
        stdout.print "#{text}: "
        value = stdin.gets
        property.send("#{field}=", value)
        property.save!
      end
    end

    private
    attr_accessor :stdin, :stdout

    PROPERTY_METHODS = {
      title: "Title",
      kind: "Property type (home, apartment, room)",
      nightly_rate: "Nightly rate (EUR)",
      address: "Address",
      max_guests: "Max. guests",
      email: "Email",
      phone: "Phone"
    }
  end
end
