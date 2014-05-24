
class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include Mongoid::Paperclip
  include Geocoder::Model::Mongoid


  field :user_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :street, type: String
  field :postal_code, type: String
  field :city, type: String
  field :country, type: String
  field :coordinates, :type => Array
  field :email, type: String
  field :phone_number, type: String
  field :connected, type: String
  field :new_contact, type: String
  field :tags, type: Array
  field :profile_picture, type: String

  has_mongoid_attached_file :avatar,
    :storage => :s3,
    :bucket => 'kyk_test',
    :s3_credentials => {
      :access_key_id => Figaro.env.amazon_key,
      :secret_access_key => Figaro.env.amazon_secret
    }
  validates_attachment_content_type :avatar, :content_type => /\Aimage/

  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  embedded_in :user

  #validates :email, uniqueness: true


  def address
    full_address = street.to_s + ", " + city.to_s + ", " + country.to_s
    return full_address
  end

  def tag_list=value

    self.tags = Array.new
    value.split(',').each do |tag|
      self.tags.push(tag.strip) unless self.tags.include?(tag)
    end
  end

  def tag_list
    self.tags.join(', ') unless self.tags.nil?
  end  

end
