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

  def property(name)
    _properties.find { |p| p.name == name }
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
    attr_reader :name, :type, :all_of, :format

    def initialize(name, type: nil, null: false, required: false, all_of: nil, format: nil)
      @name, @type, @null, @required, @all_of, @format = name, type, null, required, all_of, format
    end

    def required?
      @required
    end

    def null?
      @null
    end

    def as_json
      json = {}
      if type
        json[:type] = null? ? [type, :null] : type
      end
      json[:allOf] = all_of if all_of
      json[:format] = format if format
      json
    end
  end
end
