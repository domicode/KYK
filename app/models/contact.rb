class Contact
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
  field :postal_code, type: String
  field :city, type: String

  embedded_in :user
end
