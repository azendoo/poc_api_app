class Task
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include ActiveModel::SerializerSupport

  field :label, :type => String

  validates_presence_of :label
  alias :title :label

  belongs_to :user
  validates :user, :presence => true

  attr_accessible :label
end
