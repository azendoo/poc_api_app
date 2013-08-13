# encoding: UTF-8
class TaskSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :label, :created_at, :url

  has_one :user, embeds: :ids, include: false

  def url
    api_task_url(object)
  end
end
