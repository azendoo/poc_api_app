class AccessToken
  include Mongoid::Document
  include Mongoid::Timestamps

  self.store_in :oauth_access_tokens

  field :application_id,    type: BSON::ObjectId
  field :token,             type: String
  field :expires_in,        type: Integer
  field :updated_at,        type: DateTime
  field :created_at,        type: DateTime

  belongs_to :resource_owner, polymorphic: true
end
