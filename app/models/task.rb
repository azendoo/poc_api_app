# encoding: UTF-8
class Task
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :label, type: String

  validates_presence_of :label

  belongs_to :user
  validates :user, presence: true

  attr_accessible :label
end
