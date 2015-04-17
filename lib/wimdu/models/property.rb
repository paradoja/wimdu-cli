class Property < ActiveRecord::Base
  TYPES = %w{home apartment room}

  validates :kind, inclusion: { in: TYPES, message: "Error: must be #{TYPES.join(' or ')}" }, allow_blank: true
end
