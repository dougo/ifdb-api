module ResourceTesting
  extend ActiveSupport::Concern

  included do
    test 'is an immutable ApplicationResource' do
      assert_equal ApplicationResource, resource_class.superclass
      refute_predicate resource_class, :mutable?
    end

    test 'attributes' do
      self.class.const_get(:EXPECTED_ATTRS).each do |attr|
        assert_includes resource_class._attributes, attr
      end
    end

    test 'conforms to schema' do
      schema = resource_schema
      assert_valid_json schema, serialize(resource_fixture(:minimal))
      assert_valid_json schema, serialize(resource_fixture(:maximal))
    end
  end

  private

  def resource_name
    self.class.name =~ /(.*)Test/
    $1
  end

  def model_name
    resource_name =~ /(.*)Resource/
    $1
  end

  def resource_class
    resource_name.constantize
  end

  def resource(model)
    resource_class.new(model, {})
  end

  def serialize(model)
    JSONAPI::ResourceSerializer.new(resource_class).serialize_to_hash(resource(model))
  end

  def resource_schema
    "#{model_name}Schema".constantize.new
  end

  def resource_fixture(name)
    send(model_name.tableize, name)
  end
end
