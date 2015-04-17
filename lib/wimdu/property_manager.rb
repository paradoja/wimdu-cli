module Wimdu
  class EmptyValue < ActiveRecord::RecordInvalid
    def message
      "Validation failed: general Error: must insert a value"
    end
  end

  class PropertyManager
    def initialize(io_in, io_out)
      self.stdin = io_in
      self.stdout = io_out
    end

    def add
      stdout.puts "Starting with new property ABC1DEF2."
      property = Property.new(code: "ABC1DEF2")
      PROPERTY_METHODS.each do |field, text|
        begin
          stdout.print "#{text}: "
          stdout.flush
          value = stdin.gets
          raise EmptyValue.new(property) if value.blank?
          property.send("#{field}=", value)
          property.save!
        rescue ActiveRecord::RecordInvalid => e
          stdout.puts
          stdout.puts e.message.match(/\A[^:]+: [a-zA-Z]+ (.+)\z/).try(:[], 1)
          stdout.puts
          redo
        end
      end

    rescue Interrupt
      # do nothing
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
