require "spec_helper"

describe "Wimdu CLI" do
  let(:exe) { File.expand_path('../../bin/wimdu', __FILE__) }

  before :each do
    Property.destroy_all
  end

  describe "new" do
    let(:cmd) { "#{exe} new" }

    it "allows for entering data" do
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
      type "phone"

      sleep 1
      expect(Property.where(completed: true).count).to eq(1)
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
end
