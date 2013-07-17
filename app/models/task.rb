class Task
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include ActiveModel::SerializerSupport

  field :label, :type => String

  validates_presence_of :label
  alias :title :label

  belongs_to :owner, :class_name => 'User'
  validates :owner, :presence => true

  attr_accessible :label
end
