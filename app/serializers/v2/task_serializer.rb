# encoding: UTF-8
class V2::TaskSerializer < ActiveModel::Serializer

  embed :ids, include: true
  attributes :id, :label

  has_one :user, embeds: :ids, include: false

end
