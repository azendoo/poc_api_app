# XXX :
# See the file for specific comments.
source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'rails-api'

# Just for fun
gem 'puma'

# Just wanted to test the gem on controllers:
# Used to filter params.
gem 'strong_parameters'

# API versioning gem :
gem 'versionist'

gem 'bson_ext', '1.5.2'

# Fast JSON parser and object marshaller
gem 'oj'

# Encapsulates the JSON serialization of objects
gem 'active_model_serializers', :github => "rails-api/active_model_serializers", :branch => 'master'


gem 'rest-client'

# Used for CORS
gem 'rack-cors', :require => 'rack/cors'

# Authentication (some part will be removed if the auth is now on provider)
gem 'devise', :github => 'plataformatec/devise', :branch => 'master'
gem 'warden', :github => 'hassox/warden', :branch => 'master'
gem 'cancan', :github => 'ryanb/cancan', :branch => 'master'

# ODM
gem 'mongoid', '2.4.6'

# Debugging
group :development do
  gem 'jazz_hands'
  gem 'thin'
end

group :test do
  gem 'mongoid-rspec', '1.4.5'
  gem 'factory_girl_rails'
  # used to generate random informations in factories
  gem 'faker', git: 'git://github.com/stympy/faker.git'
  gem 'spork'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-bundler'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  # used to test json outputs in requests and serializers specs
  gem 'json_spec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'json_spec'
end
