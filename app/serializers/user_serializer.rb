class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :email, :url

  has_many :tasks, embed: :ids, include: false

  def url
    user_url(object)
  end
end
