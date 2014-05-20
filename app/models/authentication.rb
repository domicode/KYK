class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :user_id, type: String
  field :provider, type: String
  field :uid, type: String

  belongs_to :user
  
end
