# encoding: UTF-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :timeoutable

  before_save :ensure_authentication_token

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
  field :authentication_token, type: String

  has_many    :tasks, dependent: :destroy

  ## OAuth ##
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  attr_accessible :email, :password, :remember_me

  def self.find_by_email(email)
    User.where(email: {
      '$regex' => '^' + Regexp.quote(email) + '$', '$options' => 'i'
    }).first
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  def reset_authentication_token!
    reset_authentication_token
    self.save!
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
