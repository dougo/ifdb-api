class ApplicationResource < JSONAPI::Resource
  abstract

  include CompoundID

  def self.inherited(resource_class)
    super
    resource_class.immutable
  end

  def fetchable_fields
    super.select do |field|
      self.class._relationship(field) || public_send(field).present?
    end
  end

  def self.created_field
    :created
  end

  def self.default_sort
    [{ field: created_field, direction: :desc }]
  end

  class Serializer < JSONAPI::ResourceSerializer
    private

    def related_link(source, relationship)
      href = super
      includes = source.try("#{relationship.name}_includes")
      href += "?include=#{includes.join(',')}" if includes
      meta = source.try("#{relationship.name}_meta", custom_generation_options)
      if meta
        { href: href, meta: meta }
      else
        href
      end
    end
  end
end
