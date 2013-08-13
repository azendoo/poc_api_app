Proof of concept : API
===========

This project is just a sandbox where I'm trying to play with the following gems :
* Rails-API
* Mongoid
* Oj
* ActiveModel::Serializer
* active_model_version_serializer
* Devise, with master branch of Warden.
* RSpec
* api-versions
* redis-throttle
* asset_async

At the moment, everything here is experimental.
Indeed, this project is still a work in progress.

### Current middleware stack

```no-highlight
$ rake middleware

use ActionDispatch::Static
use Rack::Lock
use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007fc317082168>
use Rack::Runtime
use ActionDispatch::RequestId
use Rails::Rack::Logger
use ActionDispatch::ShowExceptions
use ActionDispatch::RemoteIp
use ActionDispatch::Reloader
use ActionDispatch::Callbacks
use ActionDispatch::ParamsParser
use ActionDispatch::Head
use Rack::ConditionalGet
use Rack::ETag
use ApiVersions::Middleware
use Rack::Cors
use Warden::Manager
use Rack::MethodOverride
use ActionDispatch::Flash
use Rack::Mongoid::Middleware::IdentityMap
use Apipie::StaticDispatcher
```

### API Versioning :

At the moment API versioning is done using [api-versions](https://github.com/erichmenge/api-versions) gem. Serializers are also versioned, but this time with [active_model_version_serializers](https://github.com/hookercookerman/active_model_version_serializers) gem, which is kinda a f-:bomb: experimental.

Everything happens in the `Accept` header. Following type are accepted :
```
application/json
application/vnd.azendoo+json
application/vnd.azendoo+json; version=1
application/vnd.azendoo+json; version=2
```

Default version is V1, so if you ask for one the first two types of the list above, you will get V1.
