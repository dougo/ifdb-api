JSONAPI.configure do |config|
  config.resource_key_type = :string
  config.default_paginator = :paged
  config.always_include_to_one_linkage_data = true
end
