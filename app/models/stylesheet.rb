class Stylesheet < ApplicationRecord
  belongs_to :author, class_name: 'Member', foreign_key: :userid
end
