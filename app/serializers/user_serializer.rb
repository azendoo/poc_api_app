# encoding: UTF-8
class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :email, :url

  has_many :tasks, embed: :ids, include: false

  def url
    api_user_url(object)
  end
end
