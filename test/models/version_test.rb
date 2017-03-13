require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  test 'is abstract' do
    assert_predicate self.class.described_type, :abstract_class?
  end

  # Shoulda's association matchers require subject to be an instance, even though all they do is call .class on it!
  # But we can't create an instance of an abstract class, so we have to make a concrete subclass.
  # TODO: fix shoulda_matchers?
  subject { Class.new(self.class.described_type) { def self.load_schema!; end }.new }

  should belong_to(:editor).class_name('Member').with_foreign_key(:editedby)
end
