class Task
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include ActiveModel::SerializerSupport

  field :label, :type => String

  belongs_to :user

  validates_presence_of         :label
  alias :title :label

  attr_accessible :label
end
