class Note
  include Mongoid::Document
  include Mongoid::Timestamps


  field :title, type: String  
  field :note, type: String


  embedded_in :contact 
end
