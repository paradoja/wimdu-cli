require "spec_helper"

describe "Wimdu CLI" do
  let(:exe) { File.expand_path('../../bin/wimdu', __FILE__) }

  before :each do
    Property.destroy_all
  end

  describe "new" do
    let(:cmd) { "#{exe} new" }

    it "allows for entering data and recording it correctly" do
      process = run_interactive(cmd)
      expect(process.output).to include("Starting with new property")
      expect(process.output).to include("Title: ")
      type "My Title"
      expect(process.output).to include("Property type")
      type "home"
      expect(process.output).to include("Nightly rate")
      type "300.1"
      expect(process.output).to include("Address:")
      type "Address"
      expect(process.output).to include("Max. guests:")
      type "3"
      expect(process.output).to include("Email:")
      type "email@example.org"
      expect(process.output).to include("Phone:")
      type "+1234"
      sleep 1
      expect(process.output).to include("Great job! Listing ABC0000 is complete!")

      expect(Property.where(completed: true).count).to eq(1)
      property = Property.first
      expect(property.title).to eq("My Title")
      expect(property.kind).to eq("home")
      expect(property.nightly_rate).to eq(300.1)
      expect(property.address).to eq("Address")
      expect(property.max_guests).to eq(3)
      expect(property.email).to eq("email@example.org")
      expect(property.phone).to eq("+1234")
    end

    it "allows entering incomplete data" do
      process = run_interactive(cmd)
      expect(process.output).to include("Starting with new property")
      expect(process.output).to include("Title: ")
      type "My Title"

      sleep 1
      process.terminate
      expect(Property.count).to eq(1)
      property = Property.first
      expect(property.title).to eq("My Title")
      expect(property.completed?).to eq(false)
    end

    it "validates empty fields" do
      process = run_interactive(cmd)
      expect(process.output).to include("Starting with new property")
      expect(process.output).to include("Title: ")
      type ""
      expect(process.output).not_to include("Property type")
      type "My Title"
      expect(process.output).to include("Property type")
    end

    it "enforces non-empty validations" do
      process = run_interactive(cmd)
      expect(process.output).to include("Starting with new property")
      expect(process.output).to include("Title: ")
      type "My Title"
      expect(process.output).to include("Property type")
      type "something else"
      expect(process.output).not_to include("Nightly rate")
      type "home"
      expect(process.output).to include("Nightly rate")
    end
  end

  describe "list" do
    let(:cmd) { "#{exe} list" }

    it "indicates there are no properties if there aren't" do
      process = run_interactive(cmd)
      expect(process.output).to include("No offers found")
    end

    it "indicates the number of properties and their data if there are" do
      Property.create!(title: 't1', completed: true)
      Property.create!(title: 't2', completed: true)

      process = run_interactive(cmd)
      expect(process.output).to include("Found 2 offers")
      expect(process.output).to include("t1")
      expect(process.output).to include("t2")
    end

    it "only indicates completed properties" do
      Property.create!(title: 't1', completed: true)
      Property.create!(title: 't2', completed: false)
      Property.create!(title: 't3', completed: true)

      process = run_interactive(cmd)
      expect(process.output).to include("Found 2 offers")
      expect(process.output).to include("t1")
      expect(process.output).not_to include("t2")
      expect(process.output).to include("t3")
    end
  end

  describe "continue" do
    before :each do
      Property.create!
    end
    let(:cmd) { "#{exe} continue ABC0000" }

    it "allows for entering data and recording it correctly" do
      process = run_interactive(cmd)
      expect(process.output).to include("Continuing with ABC0000")
      expect(process.output).to include("Title: ")
      type "My Title"
      expect(process.output).to include("Property type")
      type "home"
      expect(process.output).to include("Nightly rate")
      type "300.1"
      expect(process.output).to include("Address:")
      type "Address"
      expect(process.output).to include("Max. guests:")
      type "3"
      expect(process.output).to include("Email:")
      type "email@example.org"
      expect(process.output).to include("Phone:")
      type "+1234"
      sleep 1
      expect(process.output).to include("Great job! Listing ABC0000 is complete!")

      expect(Property.where(completed: true).count).to eq(1)
      property = Property.first
      expect(property.title).to eq("My Title")
      expect(property.kind).to eq("home")
      expect(property.nightly_rate).to eq(300.1)
      expect(property.address).to eq("Address")
      expect(property.max_guests).to eq(3)
      expect(property.email).to eq("email@example.org")
      expect(property.phone).to eq("+1234")
    end

    it "allows entering incomplete data" do
      process = run_interactive(cmd)
      expect(process.output).to include("Title: ")
      type "My Title"

      sleep 1
      process.terminate
      expect(Property.count).to eq(1)
      property = Property.first
      expect(property.title).to eq("My Title")
      expect(property.completed?).to eq(false)
    end

    it "validates empty fields" do
      process = run_interactive(cmd)
      expect(process.output).to include("Title: ")
      type ""
      expect(process.output).not_to include("Property type")
      type "My Title"
      expect(process.output).to include("Property type")
    end

    it "enforces non-empty validations" do
      process = run_interactive(cmd)
      expect(process.output).to include("Title: ")
      type "My Title"
      expect(process.output).to include("Property type")
      type "something else"
      expect(process.output).not_to include("Nightly rate")
      type "home"
      expect(process.output).to include("Nightly rate")
    end

    it "doesn't prompt for completed fields" do
      property = Property.first
      property.update(title: 'My Title', nightly_rate: '300.1')

      process = run_interactive(cmd)

      expect(process.output).to include("Continuing with ABC0000")
      expect(process.output).not_to include("Title: ")

      expect(process.output).to include("Property type")
      type "home"
      expect(process.output).not_to include("Nightly rate")
      type "300.1"
      expect(process.output).to include("Address:")
      type "Address"
      expect(process.output).to include("Max. guests:")
      type "3"
      expect(process.output).to include("Email:")
      type "email@example.org"
      expect(process.output).to include("Phone:")
      type "+1234"
      sleep 1
      expect(process.output).to include("Great job! Listing ABC0000 is complete!")

      expect(Property.where(completed: true).count).to eq(1)
      property = Property.first
      expect(property.title).to eq("My Title")
      expect(property.kind).to eq("home")
      expect(property.nightly_rate).to eq(300.1)
      expect(property.address).to eq("Address")
      expect(property.max_guests).to eq(3)
      expect(property.email).to eq("email@example.org")
      expect(property.phone).to eq("+1234")
    end
  end
end
