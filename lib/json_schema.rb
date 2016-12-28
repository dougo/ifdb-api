class JSONSchema
  def schema_uri
    JSON::Validator.validator_for_name(:draft4).uri
  end

  class_attribute :_type, :_properties

  self._properties = []

  def self.inherited(subclass)
    subclass._properties = _properties.dup
  end

  def self.type(type)
    self._type = type
  end

  def type
    _type
  end

  def self.property(name, **opts)
    _properties << Property.new(name, **opts)
  end

  def self.properties(*names, **opts)
    names.each { |name| property(name, **opts) }
  end

  def self.string(*names, **opts)
    properties(*names, type: :string, **opts)
  end

  def properties
    _properties
  end

  def required
    properties.select(&:required?).map(&:name)
  end

  def as_json
    json = {}
    json[:$schema] = schema_uri.to_s
    json[:type] = type if type
    json[:properties] = properties.map { |p| [p.name, p.as_json] }.to_h if properties.any?
    json[:required] = required if required.any?
    json
  end

  class Property
    attr_reader :name, :all_of

    def initialize(name, type: nil, null: false, required: false, all_of: nil)
      @name, @type, @null, @required, @all_of = name, type, null, required, all_of
    end

    def type
      if @null
        [@type, :null]
      else
        @type
      end
    end

    def required?
      @required
    end

    def as_json
      json = {}
      json[:type] = type if type
      json[:allOf] = all_of if all_of
      json
    end
  end
end
