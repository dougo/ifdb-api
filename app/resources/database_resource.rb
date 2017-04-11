# A singleton resource that represents the root of the site. There is no corresponding model.
class DatabaseResource < ApplicationResource
  def self._model_class
    nil
  end

  has_many *%i(games competitions clubs members)

  def initialize(*args)
    super(nil, {})
  end

  def id
    'ifdb'
  end

  def self.find_by_key(key, options = {})
    new(nil, {})
  end

  def games_fields
    { games: %w(title author published ratings) }
  end

  def competitions_fields
    { competitions: %w(title awarddate desc-summary) }
  end

  def clubs_fields
    { clubs: %w(name listed membership desc) }
  end

  def members_fields
    { members: %w(name location since profile-summary) }
  end

  class Serializer < superclass::Serializer
    def link_object(source, relationship, include_linkage = false)
      hash = super
      hash['links'].delete('self')
      hash
    end

    private
  
    def generate_link_builder(primary_resource_klass, options)
      builder = super
      LinkBuilder.new(base_url: builder.base_url, route_formatter: builder.route_formatter,
                      primary_resource_klass: builder.primary_resource_klass)
    end
  end

  class LinkBuilder < JSONAPI::LinkBuilder
    def self_link(source)
      base_url
    end
  end
end
