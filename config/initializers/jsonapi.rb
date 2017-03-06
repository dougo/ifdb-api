JSONAPI.configure do |config|
  config.resource_key_type = :string
  config.always_include_to_one_linkage_data = true
  config.default_paginator = :paged
  config.default_page_size = 20
  config.maximum_page_size = 100
end
