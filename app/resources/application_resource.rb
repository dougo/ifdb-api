class ApplicationResource < JSONAPI::Resource
  def fetchable_fields
    super.reject { |name| public_send(name).nil? }
  end

  def custom_links(_options)
    base_name = self.class.name.demodulize.sub('Resource', '').underscore
    # TODO: use schema_path helper?
    { describedby: "/schemas/#{base_name}" }
  end
end
