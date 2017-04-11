require 'test_helper'

class FetchCompetitionsTest < ActionDispatch::IntegrationTest
  include IntegrationTesting

  make_my_diffs_pretty!

  test 'fetch all data needed by the competitions index page' do
    comps = ifdb.competitions.get
    vals = comps.map do |comp|
      {
        title: comp.title,
        # TODO: number of games
        # TODO: number of divisions
        award_date: comp.try(:awarddate),
        desc_summary: comp.try(:desc_summary)
      }
    end
    # TODO: omit comps with no entries
    expected = [
      {
        title: 'IFComp 2112',
        award_date: '2112-11-17',
        desc_summary: 'The annual competition for original IF with a maximum playing time of 2 hours.'
      },
      {
        title: 'EctoComp 2012',
        award_date: '2012-11-21',
        desc_summary: nil
      },
      {
        title: 'SpeedIF 2000',
        award_date: nil,
        desc_summary: nil
      }
    ]
    assert_equal expected, vals
  end

  # TODO: sort links
end
