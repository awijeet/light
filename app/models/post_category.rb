class PostCategory
  include Mongoid::Document
  field :name, type: String  
  embeds_many :posts  
end
