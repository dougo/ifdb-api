class ApplicationResource < JSONAPI::Resource
  def fetchable_fields
    super.reject { |name| public_send(name).blank? }
  end

  def custom_links(options)
    base_name = self.class.name.demodulize.sub('Resource', '').underscore
    base_url = options[:serializer].link_builder.base_url
    { describedby: Rails.application.routes.url_helpers.schema_url(base_name, host: base_url) }
  end

  def self.default_sort
    [{ field: 'created', direction: :desc }]
  end
end
