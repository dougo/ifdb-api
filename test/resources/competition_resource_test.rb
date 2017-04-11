require 'test_helper'

class CompetitionResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(title awarddate desc_summary)

  test 'desc_summary' do
    subject._model.desc = 'A' * 300 # TODO: word breaks
    assert_equal 'A' * 240 + '...', subject.desc_summary
  end

  test 'desc_summary when nil' do
    assert_nil subject.desc_summary
  end

  test 'default_sort' do
    assert_equal [{ field: :awarddate, direction: :desc }, { field: :title, direction: :asc }],
                 self.class.described_type.default_sort
  end
end
