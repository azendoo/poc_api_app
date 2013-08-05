class Api::Docs::TasksDoc <  ActionController::Base

  def_param_group :task do
    param :task, Hash do
      param :label, String, description: "Label of the task", required: true
    end
  end

  def self.new_task
    <<-EOS
    # Request
    # curl --request POST -u <token>: http://api.azendoo.com/tasks -d "label='Just a task'"

    {
      "label": "Just a task"
    }
    EOS
  end

  def self.delete_task
    <<-EOS
    # Request
    # curl --request DELETE -u <token>: http://api.azendoo.com/tasks/51ee451d843668087e000004

    {
      "task": {}
    }
    EOS
  end

  def self.update_task
    <<-EOS
    # Request
    # curl --request PUT -u <token>: http://api.azendoo.com/tasks/51ee451d843668087e000004 -d "label='My new task label'"

    {
      "label": "My new task label"
    }
    EOS
  end

  def self.get_task
    <<-EOS
    # Request
    # curl -u <token>: http://api.azendoo.com/tasks/51ee451d843668087e000004

    {
      "id": "51ee451d843668087e000004",
      "label": "Just a task",
      "created_at": "2013-07-23T10:55:57+02:00",
      "url": "http://api.azendoo.com/tasks/51ee451d843668087e000004",
      "user_id": "51ee4470843668087e000003"
    }
    EOS
  end

  def self.get_tasks
    <<-EOS
    # Request
    # curl -u <token>: http://api.azendoo.com/tasks
    [
      {
        "id": "51ee451d843668087e000004",
        "label": "Just a task",
        "created_at": "2013-07-23T10:55:57+02:00",
        "url": "http://api.azendoo.com/tasks/51ee451d843668087e000004",
        "user_id": "51ee4470843668087e000003"
      },
      {
        "id": "51ee8d1784366812cf000002",
        "label": "Another task",
        "created_at": "2013-07-23T16:03:03+02:00",
        "url": "http://api.azendoo.com/tasks/51ee8d1784366812cf000002",
        "user_id": "51ee8cff84366812cf000001"
      }
    ]
    EOS
  end

end
