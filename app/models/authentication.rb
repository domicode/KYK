class Authentication
  include Mongoid::Document

  embedded_in :user
  
end
