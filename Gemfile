source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'rails-api'

gem 'api-versions', :github => 'erichmenge/api-versions', :branch => 'master'

# Required because Rails is not capable of calling your exception
# handlers when an error occurs during the parsing of request parameters
gem 'request_exception_handler'

gem 'bson_ext', '1.5.2'
gem 'oj'
gem 'active_model_serializers'

# ajax
gem 'rack-cors', :require => 'rack/cors'

# authentication
gem 'devise', :git => 'git@github.com:plataformatec/devise.git', :branch => 'master'
gem 'warden', :git => 'git@github.com:hassox/warden.git', :branch => 'master'

# authorization
gem 'doorkeeper'

# db
gem 'mongoid', '2.4.6'

# api
# gem 'api-versions'
gem 'apipie-rails'

group :development do
  gem 'jazz_hands'
  gem 'thin'
end

group :test do
  gem 'mongoid-rspec', '1.4.5'
  gem 'factory_girl_rails'
  gem 'faker', git: 'git://github.com/stympy/faker.git'
  gem 'spork'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-bundler'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'active_model_serializers-matchers', github: 'simonbnrd/active_model_serializers-matchers'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'json_spec'
end
