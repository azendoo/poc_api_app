class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :url

  def url
    user_url(object)
  end
end
