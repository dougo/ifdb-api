source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.0.rc1'

# Use mysql as the database for ActiveRecord.
gem 'mysql2', '>= 0.3.18', '< 0.5'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use Yaks to serialize as HAL+JSON
gem 'yaks'

# Use JR to conform to the JSON API spec.
gem 'jsonapi-resources', '~> 0.9.0'

# Use JSON Schema for JSON validation.
gem 'json-schema'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Use HyperResource to consume the API.
  gem 'hyperresource'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test do
  # DSL for Rails testing.
  gem 'shoulda', github: 'thoughtbot/shoulda'
end
