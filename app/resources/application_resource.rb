class ApplicationResource < JSONAPI::Resource
  def self.inherited(resource_class)
    super
    resource_class.immutable
  end

  def fetchable_fields
    super.reject { |name| public_send(name).blank? }
  end

  def self.default_sort
    [{ field: 'created', direction: :desc }]
  end
end
