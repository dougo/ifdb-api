require 'test_helper'

class InflectionsTest < ActiveSupport::TestCase
  test 'acronyms' do
    assert_equal({ hal: 'HAL', ifid: 'IFID' }, ActiveSupport::Inflector.inflections(:en).acronyms.symbolize_keys)
  end
end
