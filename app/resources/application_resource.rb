class ApplicationResource < JSONAPI::Resource
  def fetchable_fields
    super.reject { |name| public_send(name).nil? }
  end
end
