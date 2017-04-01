class ApplicationResource < JSONAPI::Resource
  abstract

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
    def generate_link_builder(primary_resource_klass, options)
      # Copied from parent class.
      LinkBuilder.new(
        base_url: options.fetch(:base_url, ''),
        route_formatter: options.fetch(:route_formatter, JSONAPI.configuration.route_formatter),
        primary_resource_klass: primary_resource_klass,
      )
    end
  end

  class LinkBuilder < JSONAPI::LinkBuilder
    def relationships_related_link(source, relationship, query_params={})
      href = super
      meta = relationship.options[:meta]
      if meta
        { href: href, meta: source.instance_eval(&meta) }
      else
        href
      end
    end
  end
end
