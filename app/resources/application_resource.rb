class ApplicationResource < JSONAPI::Resource
  def self.inherited(resource_class)
    super
    resource_class.immutable
  end

  def fetchable_fields
    super.select do |field|
      self.class._relationship(field) || public_send(field).present?
    end
  end

  def self.default_sort
    [{ field: 'created', direction: :desc }]
  end
end
