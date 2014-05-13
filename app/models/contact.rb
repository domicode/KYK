class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  field :first_name, type: String
  field :last_name, type: String
  field :street, type: String
  field :postal_code, type: String
  field :city, type: String
  field :country, type: String

  def address
    # "#{@street}" + " #{@postal_code}" + " #{@city}" + " #{@country}"
    "#{@street}" + " #{@city}" + " #{@country}"
  end

  embedded_in :user
end
