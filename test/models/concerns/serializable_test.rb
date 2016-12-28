require 'test_helper'

class SerializableTest < ActiveSupport::TestCase
  class TestModel
    include Serializable
    def foo; :foo; end
    def date; Time.zone.parse('2011-11-11'); end
  end

  class TestModelMapper < Yaks::Mapper
    attributes :foo, :date
  end

  test 'to_hal' do
    expected = <<END
{
  "foo": "foo",
  "date": "2011-11-11T00:00:00Z"
}
END
    assert_equal expected.chomp, TestModel.new.to_hal
  end
end
