# encoding: UTF-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :timeoutable

  ## Database authenticatable
  field :email,              type: String, null: false, default: ''
  field :encrypted_password, type: String, null: false, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :last_activity_at,   type: Time

  ## Token authenticatable
  ## TODO : remove
  field :authentication_token, type: String

  has_many    :tasks, dependent: :destroy

  ## OAuth ##
  has_many :applications,   class_name: 'Application',  as: :owner
  has_many :access_tokens,  class_name: 'AccessToken',  as: :resource_owner
  has_many :access_grants,  class_name: 'AccessGrant',  as: :resource_owner

  attr_accessible :email, :password, :remember_me

  def self.find_by_email(email)
    User.where(email: {
      '$regex' => '^' + Regexp.quote(email) + '$', '$options' => 'i'
    }).first
  end

  # TODO :
  # raise a better exception (AzException ?)
  def self.find_by_token(token)
    access_token = AccessToken.where(:token => token).first || raise(CanCan::AccessDenied)
    User.where(_id: access_token.resource_owner_id).first
  end

  # TODO : remove
  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  # TODO : remove
  def reset_authentication_token!
    reset_authentication_token
    self.save!
  end

  private

  # TODO : remove
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
