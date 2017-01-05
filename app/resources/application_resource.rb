class ApplicationResource < JSONAPI::Resource
  def fetchable_fields
    super.reject { |name| public_send(name).nil? }
  end

  def custom_links(_options)
    # TODO: use schema_path helper?
    { describedby: "/schemas/#{self.class._model_name.to_s.demodulize.underscore}" }
  end
end
