class TaskSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :label, :created_at, :url

  has_one :user, embeds: :ids, include: false

  def url
    task_url(object)
  end
end
