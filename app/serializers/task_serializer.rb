class TaskSerializer < ActiveModel::Serializer
  attributes :id, :label, :user_id, :url

  def url
    task_url(object)
  end
end
