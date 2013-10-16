class Application
  include Mongoid::Document
  include Mongoid::Timestamps

  self.store_in :oauth_applications

  field :name, :type => String
  field :uid, :type => String
  field :secret, :type => String
  field :redirect_uri, :type => String

  belongs_to :owner, :polymorphic => true
end
