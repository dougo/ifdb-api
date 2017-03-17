class MemberResource < ApplicationResource
  attributes *%i(name gender location publicemail profile created)

  has_many :games

  def custom_links(options)
    links = super
    links[:picture] = _model.picture if _model.picture.present?
    links
  end
end
