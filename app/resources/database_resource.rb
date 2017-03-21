# A singleton resource that represents the root of the site. There is no corresponding model.
class DatabaseResource < ApplicationResource
  def self._model_class
    nil
  end

  has_many *%i(games members clubs)

  def initialize(*args)
    super(nil, {})
  end

  def id
    'ifdb'
  end

  def self.find_by_key(key, options = {})
    new(nil, {})
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
    def self_link(source)
      base_url
    end
  end
end
