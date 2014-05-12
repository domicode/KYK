class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Versioning #check what id does it do

  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
  field :postal_code, type: String
  field :city, type: String

  validates :last_name, presence: true
end
