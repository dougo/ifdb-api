concern :ResourceTesting do
  include TestMethods

  included do
    test_extends ApplicationResource
  end

  class_methods do
    def test_attributes(attrs)
      define_method("test_attributes_#{attrs.join '_'}") do
        assert_same_elements attrs, self.class.described_type._attributes.keys - [:id]
      end
    end
  end
end
