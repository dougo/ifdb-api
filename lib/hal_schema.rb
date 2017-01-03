class HALSchema < JSONSchema
  class Link
    attr_reader :rel

    def initialize(rel, required: true)
      @rel, @required = rel, required
    end

    def required?
      @required
    end

    def as_json
      { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/linkObject' }
    end
  end

  class_attribute :_links

  self._links = [Link.new(:self)]

  def self.inherited(subclass)
    subclass._properties += [LinksProperty.new(subclass)]
  end

  def links
    _links
  end

  def self.links(*rels, **opts)
    rels.each { |rel| link(rel, **opts) }
  end

  def self.link(rel, **opts)
    self._links += [Link.new(rel, **opts)]
  end

  class LinksProperty < Property
    def initialize(schema_class)
      @schema_class = schema_class
      super(:_links)
    end

    def links
      @schema_class._links
    end

    def required_links
      links.select(&:required?).map(&:rel)
    end

    def as_json
      json = super
      json[:allOf] = [ { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
                       { properties: links.map { |l| [l.rel, l.as_json] }.to_h,
                         required: required_links } ]
      json
    end
  end
end
