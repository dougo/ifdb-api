class GameSchema
  def as_json
    schema = {}
    schema[:$schema] = schema_uri.to_s
    schema[:type] = type
    schema[:properties] = props.map { |p| [p.name, p.schema] }.to_h
    schema[:required] = required
    schema
  end

  private

  def self.type(type)
    @@type = type
  end

  class Property
    attr_reader :name, :all_of

    def initialize(name, type: nil, required: false, null: false, all_of: nil)
      @name, @type, @required, @null, @all_of = name, type, required, null, all_of
    end

    def type
      if null?
        [@type, :null]
      else
        @type
      end
    end

    def required?
      @required
    end

    def null?
      @null
    end

    def schema
      schema = {}
      schema[:type] = type if type
      schema[:allOf] = all_of if all_of
      schema
    end
  end

  @@props = []

  def self.prop(*names, **opts)
    names.each do |name|
      @@props << Property.new(name, **opts)
    end
  end

  def self.string(*names, **opts)
    prop(*names, type: :string, **opts)
  end

  # Here's the actual game schema definition:

  type :object
  string *%i(id title sort_title author sort_author), required: true
  string :authorExt, required: true, null: true
  prop :_links, required: true, all_of: [
         # TODO: make a DSL for these
         { '$ref': 'http://hyperschema.org/mediatypes/hal#/definitions/links' },
         { required: %i(self) }
       ]

  def schema_uri
    JSON::Validator.validator_for_name(:draft4).uri
  end
  
  def type
    @@type
  end

  def props
    @@props
  end

  def required
    @@props.select(&:required?).map(&:name)
  end
end
