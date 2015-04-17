require "spec_helper"

describe "Wimdu CLI" do
  let(:exe) { File.expand_path('../../bin/wimdu', __FILE__) }

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

      # expect(Property.where(completed: true).count).to eq(1)
      # aruba sets the db in a sub FIXME
    end
  end

  describe "list" do
    let(:cmd) { "#{exe} list" }

    it "indicates there are no properties if there aren't" do
      process = run_interactive(cmd)
      expect(process.output).to include("No offers found")
    end
  end
end
