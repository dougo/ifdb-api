class ApplicationSchema < JSONSchema
  def self.inherited(subclass)
    super
    subclass.extend 'http://jsonapi.org/schema#/definitions/resource'
    subclass.property :links, required: true do
      string :self, format: :uri, required: true
    end
  end
end
