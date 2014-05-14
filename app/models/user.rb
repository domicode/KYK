class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic
  # include Mongoid::Versioning #check what id does it do

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  authenticates_with_sorcery!

  field :first_name, type: String
  field :last_name, type: String
  field :street, type: String
  field :postal_code, type: String
  field :city, type: String
  field :country, type: String
  field :coordinates, :type => Array  

  # field :latitude, type: BigDecimal
  # field :longitude, type: BigDecimal

  embeds_many :contacts, :inverse_of => :contacts
  accepts_nested_attributes_for :contacts

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  def address
    # "#{@street}" + " #{@postal_code}" + " #{@city}" + " #{@country}"
    # "#{@street}" + " #{@city}" + " #{@country}"
    full_address = street.to_s + ", " + city.to_s + ", " + country.to_s
    full_address
  end
end
