class HALSchema < JSONSchema
  class_attribute :_links

  self._links = [:self]

  def self.inherited(subclass)
    super
    subclass._links = _links.dup
    subclass._properties << LinksProperty.new(subclass)
  end

  def links
    _links
  end

  def self.links(*names)
    names.each &method(:link)
  end

  def self.link(name)
    _links << name
  end

  class LinksProperty < Property
    def initialize(schema_class)
      @schema_class = schema_class
      super(:_links)
    end

    def links
      @schema_class._links
    end

    def as_json
      json = super
      json[:allOf] = [ { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
                       { required: @schema_class._links } ]
      json
    end
  end
end
