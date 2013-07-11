class TaskSerializer < ActiveModel::Serializer
  attributes :id, :label, :created_at, :user_id, :url

  def url
    task_url(object)
  end
end
