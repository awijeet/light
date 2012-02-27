class User
  include Mongoid::Document
    field :first_name, type: String
    field :last_name, type: String
    field :access_token, type: String
    field :uuid, type: String
    field :login_count, type: Integer
    field :email_id, type: String  
    
    has_many :likes
    validates_presence_of :uuid,:access_token,:email_id, :first_name, :last_name, :uuid
    validates_uniqueness_of :uuid
end
