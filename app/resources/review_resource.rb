class ReviewResource < ApplicationResource
  attributes *%i(summary review rating createdate moddate embargodate)
end
