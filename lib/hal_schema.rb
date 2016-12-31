class HALSchema < JSONSchema
  class Link
    attr_reader :name

    def initialize(name, required: true)
      @name, @required = name, required
    end

    def required?
      @required
    end
  end

  class_attribute :_links

  self._links = [Link.new(:self)]

  def self.inherited(subclass)
    super
    subclass._links = _links.dup
    subclass._properties << LinksProperty.new(subclass)
  end

  def links
    _links
  end

  def self.links(*names, **opts)
    names.each { |name| link(name, **opts) }
  end

  def self.link(name, **opts)
    _links << Link.new(name, **opts)
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
      links.select(&:required?).map(&:name)
    end

    def as_json
      json = super
      json[:allOf] = [ { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
                       { required: required_links } ]
      json
    end
  end
end
