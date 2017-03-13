concern :TestMethods do
  class_methods do
    def test_extends(mod)
      define_method("test_extends_#{mod}") do
        subject = self.class.described_type
        subject = subject.singleton_class unless subject.is_a? Class
        assert_operator subject, :<, mod
      end
    end
  end
end
