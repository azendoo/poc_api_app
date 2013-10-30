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

  ## XXX :
  ## It previously was the Devise's token authenticatable
  ## TODO : remove or update it to directly return the first
  ## token of a user's access tokens list (see authentication_token
  ## method below).
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

  # XXX :
  # raise a better exception (AzException ?)
  def self.find_by_token(token)
    access_token = AccessToken.where(:token => token).first || raise(CanCan::AccessDenied)
    User.where(_id: access_token.resource_owner_id).first
  end

  # XXX :
  # In the previous PoC version we were working with only one token, the
  # Devise's authentication_token. However since we started to play with
  # Doorkeeper and the OAuth2 password grant_type we had to deal with a
  # new system. Doorkeeper saves each token related to that kind of OAuth2
  # strategy in another MongoDB collection : oauth_access_tokens
  #
  # The fact is that actually with that system users now have a list of
  # tokens. Hence, if we are using the OAuth password grant_type we should
  # only consider the first token of a user's tokens list as the 'main' token.
  # That's with that token that our webapp is playing if we use that OAuth
  # strategy. We're able to generate more tokens for a user if he wants to,
  # however, on our side, we transparently (and only) use the first generated
  # token to avoid any fuss/overhead, maybe we should make that token RO from
  # the user's perspective.
  #
  # More : If we're are using the authorization code flow, generated tokens
  # will be stored by Doorkeeper in another MongoDB collection :
  # oauth_access_grants
  #
  # Finally, by switching between differents OAuth strategies Doorkeeper will
  # store tokens in different locations. And thats pretty logical.
  #
  # In the case of our main webapp I think we should still use the password
  # grant type as that webapp is a highly trusted source (from same domain etc) :
  # http://tools.ietf.org/html/rfc6749#section-4.3
  #
  # Rate-limit, in that case, should be based on API calls done by a user and not
  # by the application. That's how we could avoid abuse our 'official app' to be
  # abused by a random registered user.
  #
  # But, still in TODO list, we should be able to get the whole tokens list of
  # user by 'unifying' both Doorkeeper's oauth_* collections. Just for practical
  # reasons.
  def authentication_token
    self.authentication_token ||= self.access_tokens.first.token
  end

  private

  # XXX :
  # This is just (a WIP and) a replacement of the previous Devise.friendly_token
  # method which was called in our PoC to generate a new token. The method
  # was also based on SecureRandom. Since Doorkeeper uses a different hash
  # size we should explicitly set it to 32.
  # See :
  # https://github.com/applicake/doorkeeper/blob/master/lib/doorkeeper/oauth/helpers/unique_token.rb
  #
  # The interest to generate a token from the API could be limited since we
  # recently decided to put everything related to authentication and account mgnt
  # on the Provider. But if a day we have, thats something we should have in mind.
  def generate_token
    size = 32
    secure_method = SecureRandom.method(:hex)
    secure_method.call(size)
  end
end
