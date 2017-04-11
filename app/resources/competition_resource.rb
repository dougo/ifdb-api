class CompetitionResource < ApplicationResource
  attributes *%i(title awarddate desc_summary)

  def desc_summary
    desc = _model.desc
    desc = desc.first(240) + '...' if desc && desc.length > 240
    desc
  end

  def self.default_sort
    [{ field: :awarddate, direction: :desc }, { field: :title, direction: :asc }]
  end
end
