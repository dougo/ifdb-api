if ENV['RAILS_ENV'] == 'test'
  require_relative '../test/simplecov'
  SimpleCov.start :ifdb do
    add_filter '/bin'
  end
end

%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
).each { |path| Spring.watch(path) }
