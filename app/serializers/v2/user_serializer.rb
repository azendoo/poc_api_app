# encoding: UTF-8
class V2::UserSerializer < ActiveModel::Serializer

  embed :ids, include: true
  attributes :id, :email

  has_many :tasks, embed: :ids, include: false

end
