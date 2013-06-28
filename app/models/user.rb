class User
  include Mongoid::Document

  field :email,              :type => String
  field :encrypted_password, :type => String

  validates_uniqueness_of             :email, case_sensitive: false
  validates_presence_of               :email

  has_many    :tasks,       as: :owner,       dependent: :destroy

  attr_accessible :email, :name, :password, :remember_me

end
