require 'test_helper'

class CrossReferenceTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:from).class_name('Game').with_foreign_key(:fromid)
  should belong_to(:to).class_name('Game').with_foreign_key(:toid)
  should belong_to(:type).class_name('CrossReferenceType').with_foreign_key(:reftype)
end
