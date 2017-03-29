concern :ResourceTesting do
  include TestMethods

  included do
    test_extends ApplicationResource

    subject do
      resource_class = self.class.described_type
      resource_class.new(resource_class._model_class.new, {})
    end
  end

  class_methods do
    def test_attributes(attrs)
      define_method("test_attributes_#{attrs.join '_'}") do
        assert_same_elements attrs, self.class.described_type._attributes.keys - [:id]
      end
    end

    def test_has_many(*rels)
      rels.each do |rel|
        define_method("test_has_many_#{rel}") do
          assert_kind_of JSONAPI::Relationship::ToMany, self.class.described_type._relationship(rel)
        end
      end
    end
  end

  def serialize(model)
    serializer = JSONAPI::ResourceSerializer.new(self.class.described_type)
    serializer.serialize_to_hash(self.class.described_type.new(model, {})).with_indifferent_access[:data]
  end
end
