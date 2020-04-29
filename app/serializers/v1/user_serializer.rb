class V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :access_token
  has_many :videos
end
