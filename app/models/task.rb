class Task
  include Mongoid::Document
  field :label, :type => String

  belongs_to :owner, :class_name => 'User'

  validates :label,             :presence => true
  validates :owner,             :presence => true

  alias :title :label

  attr_accessible :label
end
