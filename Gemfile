source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'rails-api'
gem 'puma'

gem 'strong_parameters'

# api versioning
gem 'versionist'

gem 'bson_ext', '1.5.2'

# JSON
gem 'oj'
gem 'active_model_serializers', :github => "rails-api/active_model_serializers", :branch => 'master'

# ajax
gem 'rack-cors', :require => 'rack/cors'

# authentication
gem 'devise', :github => 'plataformatec/devise', :branch => 'master'
gem 'warden', :github => 'hassox/warden', :branch => 'master'

# ODM
gem 'mongoid', '2.4.6'

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
  gem 'json_spec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'json_spec'
end
