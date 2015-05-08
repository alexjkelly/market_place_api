class UserSerializer < ActiveModel::Serializer
  cached
  
  attributes :id, :email, :created_at, :updated_at, :auth_token

  has_many :products, embed: :ids
  
  def cache_key
  	[object, scope]
  end
end
