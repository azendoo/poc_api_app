class Task
  include Mongoid::Document
  field :label, :type => String
end
