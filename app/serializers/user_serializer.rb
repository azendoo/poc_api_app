# encoding: UTF-8
class UserSerializer < ActiveModel::VersionSerializer

  version :v1 do
    embed :ids, include: true
    attributes :id, :email
    has_many :tasks, embed: :ids, include: false
  end

  version :v2 do
    embed :ids, include: true
    version_attributes :v1, with: :url
    has_many :tasks, embed: :ids, include: false

    def url
      api_user_url(object)
    end
  end


end
