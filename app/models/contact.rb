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
  field :coordinates, :type => Array

  def address
    # "#{@street}" + " #{@postal_code}" + " #{@city}" + " #{@country}"
    full_address = street.to_s + ", " + city.to_s + ", " + country.to_s
    puts "+++++++++++++++++++++++++++++++++++" + full_address
    full_address
  end

  embedded_in :user
end
