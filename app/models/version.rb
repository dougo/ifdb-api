class Version < ApplicationRecord
  self.abstract_class = true

  belongs_to :editor, class_name: 'Member', foreign_key: :editedby
end
