class OffsiteReviewResource < ApplicationResource
  primary_key :reviewid

  attributes *%i(displayorder sourcename)

  def custom_links(options)
    links = super
    links[:source] = _model.sourceurl if _model.sourceurl.present?
    links[:full_review] = _model.url if _model.url.present?
    links
  end
end
