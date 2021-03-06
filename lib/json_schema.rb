class JSONSchema
  class_attribute :_builder

  class << self
    delegate :type, :property, :properties, :string, :integer, :required, :extend, to: :_builder

    def inherited(subclass)
      subclass._builder = Builder.new
      subclass._builder.top_level
    end
  end

  def initialize(&block)
    if block
      @builder = Builder.new
      @builder.instance_eval(&block)
    else
      @builder = _builder || Builder.new
    end
  end

  def schema_uri
    JSON::Validator.validator_for_name(:draft4).uri if @builder.top_level?
  end

  def type
    @builder._type
  end

  def property(name)
    properties.find { |p| p.name == name }
  end

  def properties
    @builder._properties
  end

  def required
    properties.select(&:required?).map(&:name) + @builder._required
  end

  def base
    @builder.base
  end

  def as_json
    json = {}
    json[:$schema] = schema_uri.to_s if schema_uri
    json[:allOf] = [{ '$ref': base }] if base
    json[:type] = type if type
    json[:properties] = properties.map { |p| [p.name, p.as_json] }.to_h if properties.any?
    json[:required] = required if required.any?
    json
  end

  class Builder
    def initialize
      @_properties = []
      @_required = []
    end

    attr_reader :_type, :_properties, :_required, :base

    def top_level?
      @top_level
    end

    def top_level
      @top_level = true
    end

    def type(type)
      @_type = type
    end

    def property(name, **opts, &block)
      _add_property(Property.new(name, **opts, &block))
    end

    def properties(*names, **opts, &block)
      names.each { |name| property(name, **opts, &block) }
    end

    def string(*names, **opts, &block)
      properties(*names, type: :string, **opts, &block)
    end

    def integer(*names, **opts, &block)
      properties(*names, type: :integer, **opts, &block)
    end

    def required(*names)
      @_required += names
    end

    def extend(base)
      @base = base
    end

    def _add_property(property)
      @_properties += [property]
    end
  end

  class Property
    attr_reader :name, :type, :format, :max_length, :enum, :value, :schema

    def initialize(name, type: nil, null: false, required: false, format: nil, max_length: nil, enum: nil,
                   value: nil, &block)
      @name, @type, @null, @required, @format, @max_length = name, type, null, required, format, max_length
      @enum, @value = enum, value
      @schema = JSONSchema.new(&block) if block
    end

    def required?
      @required
    end

    def null?
      @null
    end

    def as_json
      json = schema ? schema.as_json : {}
      if type
        json[:type] = null? ? [type, :null] : type
      end
      json[:format] = format if format
      json[:maxLength] = max_length if max_length
      json[:enum] = enum if enum
      json[:enum] = [value] if value
      json
    end
  end
end
