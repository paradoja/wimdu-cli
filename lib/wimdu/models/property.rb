class Property < ActiveRecord::Base
  before_create :add_code

  TYPES = %w{home apartment room}

  validates :kind, inclusion: { in: TYPES, message: "Error: must be #{TYPES.join(' or ')}" }, allow_blank: true

  private

  def add_code
    count = "%04d" % Property.count
    self.code = "ABC#{count}"
  end
end
