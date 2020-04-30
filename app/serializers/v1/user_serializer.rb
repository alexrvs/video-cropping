class V1::UserSerializer < ActiveModel::Serializer
  attributes :access_token
  has_many :videos
end
