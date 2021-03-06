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
      property = Property.create!
      stdout.puts "Starting with new property #{property.code}."
      add_fields(property, PROPERTY_METHODS)
    end

    def list
      completed = Property.where(completed: true)
      count = completed.count
      if count.zero?
        stdout.puts "No offers found."
      else
        stdout.puts "Found #{count} offer#{count > 1 ? 's' : ''}"
        stdout.puts
        completed.each do |property|
          stdout.puts "#{property.code}: #{property.title}"
        end
      end
    end

    def continue(code)
      property = Property.find_by(code: code)
      if property.nil?
        stdout.puts "Error: Property not found."
        return
      elsif property.completed?
        stdout.puts "Error: Property fully completed."
        return
      end

      stdout.puts "Continuing with #{property.code}."

      empty_fields = PROPERTY_METHODS.select do |field, _|
        property.send(field).nil? ||
          (property.respond_to?(:empty?) && property.send(field).empty?)
      end

      add_fields(property, empty_fields)
    end

    private
    attr_accessor :stdin, :stdout

    def add_fields(property, methods)
      methods.each do |field, text|
        begin
          stdout.print "#{text}: "
          stdout.flush
          value = stdin.gets.strip
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
      property.update!(completed: true)
      stdout.puts "Great job! Listing #{property.code} is complete!"
    rescue Interrupt
      # do nothing
    end

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
