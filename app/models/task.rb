class Task
  include Mongoid::Document

  field :label, :type => String

  belongs_to :owner, :class_name => 'User'

  validates_presence_of         :label
  validates_presence_of         :owner

  alias :title :label

  attr_accessible :label

end
