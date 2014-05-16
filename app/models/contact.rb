
class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic


  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  field :user_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :street, type: String
  field :postal_code, type: String
  field :city, type: String
  field :country, type: String
  field :coordinates, :type => Array
  field :email, type: String
  field :connected, type: String
  field :new_contact, type: String

  def address
    full_address = street.to_s + ", " + city.to_s + ", " + country.to_s
  end

  embedded_in :user

  #validates :email, uniqueness: true

end
