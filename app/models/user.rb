class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic
  # include Mongoid::Versioning #check what id does it do

  authenticates_with_sorcery!

  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
  field :postal_code, type: String
  field :city, type: String

  embeds_many :contacts, :inverse_of => :contacts

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
end
