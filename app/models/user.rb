class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic
  # include Mongoid::Versioning

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

  before_save :update_contacts_attributes, unless: :contacts_changed?

  def update_contacts_attributes

    # id = current_user.id
    # contacts = Contact.where()
    puts "++++++++++++++++++++++++++++++++++ update contact attributes"
      User.all.each do |user|
        user.contacts.each do |contact|
          if contact.user_id.to_s == self.id.to_s
            contact.attributes.each do |key, value|
              # if key != ""
              # contact.update({ 'key' => @user.key })
              puts "key: " + key
              puts "value: " + value.to_s
            # end
          end
        end
      end
    end
  end

  def contacts_changed?
    self.contacts.each do |contact|
      return true if contact.changed?
    end
    return false
  end


  def address
    # "#{@street}" + " #{@postal_code}" + " #{@city}" + " #{@country}"
    # "#{@street}" + " #{@city}" + " #{@country}"
    full_address = street.to_s + ", " + city.to_s + ", " + country.to_s
    full_address
  end
end
