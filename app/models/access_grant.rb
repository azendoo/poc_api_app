class AccessGrant
  include Mongoid::Document
  include Mongoid::Timestamps

  self.store_in :oauth_access_grants

  field :application_id, :type => Hash
  field :token, :type => String
  field :expires_in, :type => Integer
  field :redirect_uri, :type => String
  field :revoked_at, :type => DateTime

  belongs_to :resource_owner, polymorphic: true
end
