class ReviewResource < ApplicationResource
  attributes *%i(summary review rating createdate moddate embargodate)

  has_one :reviewer, foreign_key: :userid

  def self.created_field
    :moddate
  end
end
