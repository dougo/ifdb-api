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

  class Serializer < superclass::Serializer
    def link_object(source, relationship, include_linkage = false)
      hash = super
      hash['links'].delete('self')
      hash
    end
  end

  class LinkBuilder < superclass::LinkBuilder
    def self_link(source)
      base_url
    end
  end
end
