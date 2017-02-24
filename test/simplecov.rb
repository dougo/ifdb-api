require 'simplecov'

SimpleCov.profiles.define :ifdb do
  load_profile :test_frameworks

  add_filter '/config/'
  add_filter '/db/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Mappers', 'app/mappers'
  add_group 'Models', 'app/models'
  add_group 'Resources', 'app/resources'
  add_group 'Schemas', 'app/schemas'
  add_group 'Libraries', 'lib'

  track_files '{app,lib}/**/*.rb'
end
