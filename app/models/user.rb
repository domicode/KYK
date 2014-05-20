class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  # include Mongoid::Versioning

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

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
  has_many :authentications#, :inverse_of => :authentications #, :dependent => :destroy (have to fix that)
  accepts_nested_attributes_for :authentications


  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: :password, presence: true

  before_save :update_contacts_attributes, unless: :contacts_changed?

  def update_contacts_attributes
    User.all.each do |user|
      user.contacts.each do |contact|
        if contact.user_id.to_s == self.id.to_s
          contact.attributes.each do |key, value|
            if key.to_s == "_id" || 
              key.to_s == "user_id" || 
              key.to_s == "coordinates" || 
              key.to_s == "notes" || 
              key.to_s == "connected" ||
              key.to_s == "new_contact"
              
            elsif self.attributes[key] != ""
              contact.update({ key => self.attributes[key] })
            end
          end
        end
      end
    end
  end

  def tags_array
    all_tags = []
    self.contacts.each do |contact|
      unless contact.tags.nil?
        contact.tags.each do |tag|
          all_tags.push(tag) unless all_tags.include?(tag)
        end
      end
    end
    all_tags
  end

  def tags_with_weight
    all_tags_with_weight = Hash[self.tags_array.map { |tag| [tag, 0]}]
    self.contacts.each do |contact|
      unless contact.tags.nil?
        contact.tags.each do |tag|
          all_tags_with_weight[tag] += 1
      end
    end
  end
  all_tags_with_weight.to_a
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
    return full_address
  end
end
