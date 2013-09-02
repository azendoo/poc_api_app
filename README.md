Proof of concept : API
===========

This project is just a sandbox where I'm trying to play with the following gems :
* Rails-API
* Mongoid
* Oj
* ActiveModel::Serializer (with some customizations in order to support versioning)
* Devise, with master branch of Warden.
* RSpec
* versionist
* redis-throttle
* asset_async

At the moment, everything here is experimental.
Indeed, this project is still a work in progress.

### Current middleware stack

```no-highlight
$ rake middleware

use ActionDispatch::Static
use Rack::Lock
use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007ffb44b234b8>
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
use Versionist::Middleware
use Rack::Cors
use Warden::Manager
use Rack::MethodOverride
use ActionDispatch::Flash
use Rack::Mongoid::Middleware::IdentityMap
use Apipie::StaticDispatcher
```

### API Versioning :

Everything happens in the `Accept` header. Following type are accepted :
```
application/json
application/vnd.azendoo+json
application/vnd.azendoo+json; version=1
application/vnd.azendoo+json; version=2
```

Default version is V1, so if you ask for one the first two types of the list above, you will get V1.
